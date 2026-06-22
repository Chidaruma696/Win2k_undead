#!/bin/bash
while true
do
    sleep 0.8
    if [ "$(ls /home/$USER/.local/share/Trash/files)" != "" ]; then
	    internal_full_of_trash="1"
    else
	    internal_full_of_trash="0"
    fi
	
	drives="$(ls /media/$USER)"
	for drive in $drives; do
		if [ "$(ls /media/$USER/$drive/.Trash-*/files)" != "" ]; then
			external_full_of_trash="1"
			break
		else
			external_full_of_trash="0"
		fi
	done

	if [ "$internal_full_of_trash" == "1" ] || [ "$external_full_of_trash" == "1" ]; then
	    cp /home/$USER/.local/share/sounds/Win2k/stereo/bin2.desktop "$(xdg-user-dir DESKTOP)/bin.desktop"
	else
		cp /home/$USER/.local/share/sounds/Win2k/stereo/bin1.desktop "$(xdg-user-dir DESKTOP)/bin.desktop"
	fi
done
