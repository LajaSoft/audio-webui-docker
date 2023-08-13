#!/usr/bin/env bash

eval /app/.env
python3 -m venv venv
eval venv/bin/activate
pip install --upgrade numpy==1.23.5
/app/audio-webui/run.sh --listen
