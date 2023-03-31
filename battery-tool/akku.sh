#!/usr/bin/env bash

function enable_discharging() {
	sudo ./smc -k CH0I -w 01
}

function disable_discharging() {
	sudo ./smc -k CH0I -w 00
}

function enable_charging() {
	sudo ./smc -k CH0B -w 00
	sudo ./smc -k CH0C -w 00
	disable_discharging
}

function disable_charging() {
	sudo ./smc -k CH0B -w 02
	sudo ./smc -k CH0C -w 02
}

function get_discharging_status() {
    ./smc -k CH0I -r
}

function get_charging_status() {
    ./smc -k CH0B -r
}

function usage() {
    echo "Usage: $0 [argument]"
    echo "Arguments: charge, discharge, maintain, status"
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

case $1 in
    "charge")
        echo "Enabling charging"
        enable_charging
        ;;
    "discharge")
        echo "Enabling discharging"
        enable_discharging
        ;;
    "maintain")
        echo "Maintaining current charge"
        disable_charging
        ;;
    "status")
        echo "Charging status: $(get_charging_status)"
        echo "Discharging status: $(get_discharging_status)"
        ;;
    *)
        usage
        ;;
esac
