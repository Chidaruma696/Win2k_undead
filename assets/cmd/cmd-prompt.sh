# Win2k Undead - MS-DOS / Command Prompt style for bash.
# Sourced from ~/.bashrc. Turns the bash prompt into a Windows  C:\...>  prompt.

# Build a Windows-looking path from $PWD:
#   /home/<user>        -> C:\Users\<user>
#   /home/<user>/foo    -> C:\Users\<user>\foo
#   anything else (/etc) -> C:\etc
win2k_cmd_path() {
    local p="$PWD"
    case "$p" in
        "$HOME")    p="/Users/$USER" ;;
        "$HOME"/*)  p="/Users/$USER/${PWD#"$HOME"/}" ;;
    esac
    p="C:$p"
    # flip slashes to backslashes (pure bash, no sed dependency)
    printf '%s' "${p//\//\\}"
}

# Many distros rebuild the prompt every command via PROMPT_COMMAND, which would
# overwrite ours. Clear it so our PS1 sticks, then set the cmd-style prompt.
PROMPT_COMMAND=""
export PS1='$(win2k_cmd_path)> '

# Print the classic banner once per interactive session.
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
