#!/bin/bash
drives="$(ls /media/$USER)"
canberra-gtk-play -f /home/$USER/.local/share/sounds/Win2k/stereo/dialog-information.wav &
if zenity --question --title="Confirm Multiple File Delete" --icon-name=trashout --ok-label="Yes" --cancel-label="No" --text="Are you sure you want to delete these $(ls -1 /home/$USER/.local/share/Trash/files/ | wc -l) items?"; then
#if zenity --question --title="Επιβεβαιώστε τη διαγραφή πολλαπλών αρχείων" --icon-name=trashout --ok-label="Ναί" --cancel-label="Όχι" --text="Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτά τα $(ls -1 /home/$USER/.local/share/Trash/files/ | wc -l) στοιχεία;"; then
   rm -rf /home/$USER/.local/share/Trash/files/*
   for drive in $drives; do
        rm -rf /media/$USER/$drive/.Trash-*/files/*
   done
   canberra-gtk-play -f /home/$USER/.local/share/sounds/Win2k/stereo/trash-empty.wav
fi

exit 0