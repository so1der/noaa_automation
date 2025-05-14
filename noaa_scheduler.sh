#!/bin/bash

# This bash script is calculating best pass of NOAA 18 or NOAA 19 in given time range, using "predict" software (by KD2BD).
# After that, scheduling the execution of commands to record, process, and post image to Mastodon.

# Set time range for satellites prediction (36000 seconds = 10 hours)
predict_start=$(date -d "now" +%s)
predict_end=$((predict_start + 36000))

# Determine highest elevation angle in specified time range of NOAA 18 and NOAA 19
read -r elev18 time18 <<< $(/usr/local/bin/predict -t tle.txt -f "NOAA 18" $predict_start $predict_end | awk '{print $5, $1}' | sort -nr | head -n1)
read -r elev19 time19 <<< $(/usr/local/bin/predict -t tle.txt -f "NOAA 19" $predict_start $predict_end | awk '{print $5, $1}' | sort -nr | head -n1)

# Determine which satellite has better elevation angle
better_pass=$(awk -v e18="$elev18" -v e19="$elev19" 'BEGIN {print (e18 > e19) ? 18 : 19}')
if [ "$better_pass" -eq 18 ]; then
    sat="noaa_18"
    nu=18
    peak=$time18
    elev=$elev18
else
    sat="noaa_19"
    nu=19
    peak=$time19
    elev=$elev19
fi

# Calculate time variables and set filenames
# 450 = 7.5 minutes usually half time of the good satellite pass
# 120 = 2 minutes pause between each 'at' command, to ensure that they do not overlap each other
start_pass=$((peak - 450))
end_pass=$((peak + 450))
process_image_time=$((end_pass + 120))
posting_image_time=$((process_image_time + 120))
formated_date=$(LC_TIME=uk_UA.UTF-8 date -d @$start_pass "+%A %d.%m.%Y %H:%M:%S")
filename="${sat}_$(date -d @$start_pass +%d_%m_%y_%H%M%S).wav"
image="${sat}_$(date -d @$start_pass +%d_%m_%y_%H%M%S).jpg"

# Set frequency depending on satellite
[[ $nu -eq 19 ]] && freq="137.1M" || freq="137.9125M"

# Schedule the command execution for satellite pass recording, image processing, and publishing image to Mastodon
# 'sleep' is used to achieve second precision, since 'at' does not work with seconds
echo "sleep $(date -d @$start_pass +%S); /usr/local/bin/rtl_fm -f $freq -s 80k -g 49.6 -p 0 -F 9 -E dc | sox -t raw -r 80k -e signed -b16 -c1 - $filename trim 0 900" | at $(date -d @$start_pass +%H%M)
echo "bash process_image.sh $filename $start_pass" | at $(date -d @$process_image_time +%H%M)
echo "bash post_image.sh $image \"$elev\" \"$formated_date\" && bash move_processed_files.sh $filename $image" | at $(date -d @$posting_image_time +%H%M) 

# Save logs into logfile_noaa
{
  echo $(date +"%Y-%m-%d %H:%M:%S")
  echo "Scheduled $sat"
  echo "Elevation: $elev°"
  echo "From $(date -d @$start_pass +"%H:%M:%S") to $(date -d @$end_pass +"%H:%M:%S")"
  echo "Peak elevation time: $(date -d @$peak +"%H:%M:%S")"
  echo "Filename: $filename"
  echo "Image name: $image"
  echo "Image Processing Time: $(date -d @$process_image_time +"%H:%M:%S")"
  echo "Image Posting Time: $(date -d @$posting_image_time +"%H:%M:%S")"
  echo ""
} | tee -a logfile_noaa

