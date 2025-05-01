#!/bin/bash

# This bash script uses "noaa-apt image decoder" software to decode image from satellite.
# After that it uses ImageMagick to compress PNG into JPG, and removes PNG file.

wav_file=$1
time=$(($2+4))
satellite=${wav_file:0:7}
image_name="${satellite}_$(date -d @$2 +%d_%m_%y_%H%M%S).png"
compressed_image_name="${satellite}_$(date -d @$2 +%d_%m_%y_%H%M%S).jpg"

mv $wav_file noaa-apt/
cd noaa-apt/

./noaa-apt $wav_file -Fc histogram -P res/palettes/noaa-apt-daylight.png -R no -o $image_name -s $satellite -T ../tle.txt -t $(date -u -d @$time +"%Y-%m-%dT%H:%M:%S%:z") -m yes

magick $image_name -flatten -quality 80 $compressed_image_name

rm $image_name
