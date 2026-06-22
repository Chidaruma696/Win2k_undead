# Win2k Undead - MS-DOS / Command Prompt style for bash.
# Sourced from ~/.bashrc. Shows a  C:\path\like\this>  prompt.
# Based on the classic "Emulate the MS-DOS prompt" trick (L. Szathmary, 2011).

# Convert the current path to a backslashed, drive-letter-ish form.
win2k_msdos_pwd() {
    printf '%s' "$PWD" | sed 's:/:\\:g'
}

export PS1='C:$(win2k_msdos_pwd)> '

# Print the classic banner once, only for interactive shells.
case $- in
    *i*)
        if [ -z "${WIN2K_BANNER_SHOWN:-}" ]; then
            echo "Microsoft Windows 2000 [Version 5.00.2195]"
            echo "(C) Copyright 1985-2000 Microsoft Corp."
            echo
            export WIN2K_BANNER_SHOWN=1
        fi
        ;;
esac
