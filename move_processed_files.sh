#!/bin/bash

# This bash script moves audio file into "Recordings" folder, and image into "Pictures" folder.

cd $HOME/noaa-apt/
mv $1 $HOME/Recordings/
mv $2 $HOME/Pictures/
