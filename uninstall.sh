#!/usr/bin/env bash
#
# Win2k Undead :: uninstaller
# Reverts everything install.sh creates. Touches ONLY files this project
# installed; never removes pacman-managed packages or default XFCE assets.

set -euo pipefail

GTK_THEME="Win2K"; GTK_THEME_NL="Win2K_NoLabel"
ICON_THEME="Win2k"; CURSOR_THEME="Win2K_Cursor"; SOUND_THEME="Win2k"
BACKUP_DIR="$HOME/.config/win2k_undead"
GTK_USER_CSS="$HOME/.config/gtk-3.0/gtk.css"
CSS_BEGIN="/* >>> win2k_undead xfdesktop fix (do not edit between markers) */"
CSS_END="/* <<< win2k_undead xfdesktop fix */"
BASHRC="$HOME/.bashrc"
BASHRC_BEGIN="# >>> win2k_undead cmd prompt >>>"
BASHRC_END="# <<< win2k_undead cmd prompt <<<"
CMD_PROMPT_DST="$HOME/.config/win2k_undead/cmd-prompt.sh"

c_blue=$'\e[1;34m'; c_grn=$'\e[1;32m'; c_yel=$'\e[1;33m'; c_rst=$'\e[0m'
say()  { printf '%s==>%s %s\n' "$c_blue" "$c_rst" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$c_grn"  "$c_rst" "$*"; }
warn() { printf '%s  !!%s %s\n' "$c_yel"  "$c_rst" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

[ "$(id -u)" -ne 0 ] || { echo "Run as your normal user, not root."; exit 1; }

say "Removing Win2k Undead"

# 1) System-wide assets ------------------------------------------------------
say "Removing /usr/share assets (sudo)"
sudo rm -rf "/usr/share/themes/$GTK_THEME" "/usr/share/themes/$GTK_THEME_NL" \
            "/usr/share/icons/$ICON_THEME" "/usr/share/icons/$CURSOR_THEME" \
            "/usr/share/sounds/$SOUND_THEME" /usr/share/fonts/Win2k
# Only the wallpapers we added (leave /usr/share/backgrounds/xfce defaults alone)
for w in windows2k.png windows-2000-2y-1920x1080.jpg \
         windows-2000-datacenter-server-light.png windows-2000-datacenter-server.png \
         WindowsGruvboxWallpaper.png lockscreen.png; do
  sudo rm -f "/usr/share/backgrounds/$w"
done
have fc-cache && sudo fc-cache -f >/dev/null 2>&1 || true
ok "System assets removed"

# 2) User gtk.css fix block --------------------------------------------------
if [ -f "$GTK_USER_CSS" ] && grep -qF "$CSS_BEGIN" "$GTK_USER_CSS"; then
  tmp="$(mktemp)"
  awk -v b="$CSS_BEGIN" -v e="$CSS_END" \
      '$0==b{skip=1} !skip{print} $0==e{skip=0}' "$GTK_USER_CSS" > "$tmp"
  mv "$tmp" "$GTK_USER_CSS"
  ok "Removed xfdesktop fix block from ~/.config/gtk-3.0/gtk.css"
fi

# 3) Desktop icons -----------------------------------------------------------
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
rm -f "$DESKTOP_DIR"/win2k-*.desktop
ok "Removed Win2k desktop icons"

# 4) Reset appearance to sane defaults --------------------------------------
say "Resetting theme settings to defaults"
xfconf-query -c xsettings -p /Net/ThemeName         -s "Adwaita"   2>/dev/null || true
xfconf-query -c xsettings -p /Net/IconThemeName     -s "Adwaita"   2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/CursorThemeName   -s "default"   2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/FontName          -s "Sans 10"   2>/dev/null || true
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Monospace 10" 2>/dev/null || true
xfconf-query -c xfwm4     -p /general/theme         -s "Default"   2>/dev/null || true
xfconf-query -c xfwm4     -p /general/use_compositing -s true      2>/dev/null || true
ok "Appearance reset (you can pick any theme in Settings > Appearance)"

# 5) Command Prompt terminal look -------------------------------------------
if [ -f "$BASHRC" ] && grep -qF "$BASHRC_BEGIN" "$BASHRC"; then
  tmp="$(mktemp)"
  awk -v b="$BASHRC_BEGIN" -v e="$BASHRC_END" \
      '$0==b{skip=1} !skip{print} $0==e{skip=0}' "$BASHRC" > "$tmp"
  mv "$tmp" "$BASHRC"
  ok "Removed Command Prompt block from ~/.bashrc"
fi
rm -f "$CMD_PROMPT_DST" "$HOME/.config/xfce4/terminal/terminalrc"

# 6) Panel: restore the stock XFCE default layout ---------------------------
say "Restoring the default XFCE panel"
xfce4-panel --quit >/dev/null 2>&1 || true
sleep 1
xfconf-query -c xfce4-panel -p /panels  -rR 2>/dev/null || true
xfconf-query -c xfce4-panel -p /plugins -rR 2>/dev/null || true
rm -rf "$HOME/.config/xfce4/panel/launcher-3"
# Drop the cached panel config so XFCE regenerates its built-in default layout.
rm -f "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
pkill -x xfconfd >/dev/null 2>&1 || true
sleep 1
if have xfce4-panel && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
  nohup xfce4-panel >/dev/null 2>&1 &
  disown 2>/dev/null || true
fi
ok "Default panel restored"

if [ -d "$BACKUP_DIR" ]; then
  warn "Your pre-install settings dump is kept at: $BACKUP_DIR"
  warn "Delete it with: rm -rf \"$BACKUP_DIR\""
fi

echo
say "${c_grn}Done.${c_rst} Log out and back in to fully reset the session."
