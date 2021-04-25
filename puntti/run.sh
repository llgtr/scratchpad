#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]]; then
    open -a Simulator
    flutter run
else
    echo "Only on mac"
fi
