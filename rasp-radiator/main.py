import requests
import os
from datetime import datetime, timedelta


# WEATHER
def format_HHMM(timestamp):
    return datetime.fromtimestamp(timestamp).strftime("%H:%M")


appid = os.environ['WEATHER_APPID']
latlon = os.environ['LATLON']
lat = latlon.split(',')[0]
lon = latlon.split(',')[1]
parameters = {
    'lat': lat,
    'lon': lon,
    'exclude': 'daily,minutely',
    'units': 'metric',
    'appid': appid
}
weather_url = "https://api.openweathermap.org/data/2.5/onecall"

r = requests.get(weather_url, parameters)
current = r.json()['current']
hourly = r.json()['hourly']

datetime_updated = format_HHMM(current['dt'])
sunrise = format_HHMM(current['sunrise'])
sunset = format_HHMM(current['sunset'])
uvi = round(current['uvi'], 1)
wind_speed = current['wind_speed']
wind_deg = current['wind_deg']
description = current['weather'][0]['description']
print(f'updated: {datetime_updated}')
print(f'description: {description}')
print(f'sunrise: {sunrise}')
print(f'sunset: {sunset}')
print(f'uvi: {uvi}')
print(f'wind speed: {wind_speed} m/s')
print(f'wind deg: {wind_deg}°')
for hour in hourly[:12:2]:
    time_str = format_HHMM(hour['dt'])
    temp, feels_like = round(hour['temp'], 1), round(hour['feels_like'], 1)
    rain_prob = hour['pop']
    print(f'{time_str} -> {temp} ({feels_like}) - {rain_prob}')

# HSL
hsl_url = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
stop_id = os.environ['STOPID']
query = f"""
    {{
      stop(id: "{stop_id}") {{
        name
        stoptimesWithoutPatterns {{
          headsign
          scheduledDeparture
          realtimeDeparture
        }}
      }}
    }}
    """
r2 = requests.post(hsl_url, json={'query': query}).json()['data']['stop']

print(r2['name'])
for stoptime in r2['stoptimesWithoutPatterns']:
    headsign = stoptime['headsign']
    dep_delta = timedelta(seconds=stoptime['realtimeDeparture'])
    print(f'{headsign} @ {":".join(str(dep_delta).split(":")[:2])}')
