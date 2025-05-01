#!/bin/bash

# This bash script is downloading TLE (Two Line Element set) for weather satellites, required for satellite passes prediction, and image processing (map overlay).
# Since TLE files tend to lose its relevance over time, this script should be running regulary, for example once every 2-3 days.

wget -q https://celestrak.org/NORAD/elements/weather.txt -O temp_tle && mv temp_tle tle.txt
