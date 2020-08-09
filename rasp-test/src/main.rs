use std::error::Error;
use std::fs::File;
use std::io::BufReader;
use std::path::Path;

use serde::{Deserialize, Serialize};
use serde_json::value::Value;
use chrono::{FixedOffset, TimeZone};

#[derive(Deserialize, Clone)]
struct Config {
    appid: String,
    stopid: String,
    lat: String,
    lon: String
}

#[derive(Serialize)]
struct WeatherApiParams {
    lat: String,
    lon: String,
    exclude: String,
    units: String,
    appid: String
}

#[derive(Deserialize, Debug)]
struct WeatherType {
    description: String,
}

#[derive(Deserialize, Debug, Default)]
struct RainType {
    #[serde(rename = "1h")]
    hour_rain: f32
}

#[derive(Deserialize, Debug)]
struct CurrentWeather {
    dt: i64,
    sunrise: i64,
    sunset: i64,
    uvi: f32,
    weather: Vec<WeatherType>,
    wind_deg: u32,
    wind_speed: f32
}

#[derive(Deserialize, Debug)]
struct HourlyWeather {
    dt: i64,
    feels_like: f32,
    pop: f32,
    temp: f32,
}

#[derive(Deserialize)]
struct WeatherApiResponse {
    timezone_offset: i32,
    current: CurrentWeather,
    hourly: Vec<HourlyWeather>
}

#[derive(Deserialize, Debug)]
struct Stoptime {
    headsign: String,
    realtimeDeparture: i64,
}

#[derive(Deserialize, Debug)]
struct Stop {
    name: String,
    stoptimesWithoutPatterns: Vec<Stoptime>
}

#[derive(Deserialize, Debug)]
struct StopData {
    stop: Stop
}

#[derive(Deserialize, Debug)]
struct HslApiResponse {
    data: StopData
}

fn read_config_from_file<P: AsRef<Path>>(path: P) -> Result<Config, Box<dyn Error>> {
    let file = File::open(path)?;
    let reader = BufReader::new(file);

    let config = serde_json::from_reader(reader)?;

    Ok(config)
}

fn get_weather_info(config: Config, client: &reqwest::blocking::Client) -> WeatherApiResponse {
    let api_url = "https://api.openweathermap.org/data/2.5/onecall";
    let params = WeatherApiParams {
        lat: config.lat,
        lon: config.lon,
        exclude: String::from("daily,minutely"),
        units: String::from("metric"),
        appid: config.appid
    };
    return serde_json::from_str(&client.get(api_url)
        .query(&params)
        .send().unwrap().text().unwrap()).unwrap();
}

fn get_stop_info(stopid: &str, client: &reqwest::blocking::Client) -> HslApiResponse {
    let api_url = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql";
    let query = format!("
{{
    stop(id: \"{}\") {{
        name
        stoptimesWithoutPatterns {{
            headsign
            realtimeDeparture
        }}
    }}
}}
", stopid);

    return serde_json::from_str(&client.post(api_url)
        .body(query)
        .send().unwrap().text().unwrap()).unwrap();
}

fn main() {
    let config = read_config_from_file("config.json").unwrap();
    let client = reqwest::blocking::Client::new();

    let weather_info = get_weather_info(config.clone(), &client);
    let current_weather = &weather_info.current;
    let hourly_weather = &weather_info.hourly;

    let offset = FixedOffset::east(weather_info.timezone_offset);

    let updated_at = offset.timestamp(current_weather.dt, 0);
    let description = &current_weather.weather.get(0).unwrap().description;
    let sunrise = offset.timestamp(current_weather.sunrise, 0);
    let sunset = offset.timestamp(current_weather.sunset, 0);
    let uvi = &current_weather.uvi;
    let wind_speed = &current_weather.wind_speed;
    let wind_deg = &current_weather.wind_deg;
    println!("{}", updated_at);
    println!("{}", description);
    println!("{}", sunrise);
    println!("{}", sunset);
    println!("{:.2}", uvi);
    println!("{} m/s", wind_speed);
    println!("{}°", wind_deg);

    for hour in hourly_weather.iter().step_by(2).take(6) {
        let hour_at = offset.timestamp(hour.dt, 0);
        let temp = hour.temp;
        let feels_like = hour.feels_like;
        let rain_prob = hour.pop;
        println!("{} -> {} ({}) - {}", hour_at, temp, feels_like, rain_prob);
    }

    let stop_info = get_stop_info(&config.stopid, &client).data.stop;
    println!("{}", stop_info.name);
    for stoptime in stop_info.stoptimesWithoutPatterns.iter().take(2) {
        let headsign = &stoptime.headsign;
        let dep_delta = stoptime.realtimeDeparture;
        println!("{} @ {}", headsign, dep_delta);
    }
}
