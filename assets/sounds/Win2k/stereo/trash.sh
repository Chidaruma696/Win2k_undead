#!/bin/bash
cd /home/$USER/.local/share/Trash/files
while true
do
    TOT1="$(ls -1 | wc -l)"
    sleep 0.5
    TOT2="$(ls -1 | wc -l)"
    if [ "$TOT1" -gt "$TOT2" ]; then
        canberra-gtk-play -f /home/$USER/.local/share/sounds/Win2k/stereo/trash-empty.wav
    fi
done
