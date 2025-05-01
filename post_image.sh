#!/bin/bash

# This bash scripts activates Python Virtual Environment, and executes Python script to post image to Mastodon.
# It requires image filename ($1), elevation angle ($2), and date ($3)

cd $HOME/python-mastodon/
source venv/bin/activate

python poster.py $1 "$2" "$3"  >> logfile_python
