#!/usr/bin/env bash
#
# Win2k Undead  ::  Windows 2000 look & feel for XFCE on Arch Linux
# ----------------------------------------------------------------------------
# Fork of the "Win2k" total conversion, rebuilt for Arch Linux + XFCE 4.18/4.20.
#
# Design goals (why this is different from the original Debian project):
#   * APPEARANCE ONLY  - themes, icons, cursors, fonts, sounds, wallpapers,
#                        panel layout and desktop icons. No fake utilities,
#                        no bundled Wine/IE/WMP, no system binaries.
#   * UPDATE-SAFE      - does NOT touch /usr/lib/os-release, /etc/lsb-release,
#                        does NOT purge or replace any pacman-managed package.
#                        A `pacman -Syu` can never break this install.
#   * ARCH-NATIVE      - no dpkg/apt/.deb. Optional deps come from pacman.
#   * BILINGUAL        - desktop entries carry English + Spanish (Name[es]).
#                        Your locale decides which one shows automatically.
#
# Assets install system-wide under /usr/share (needs sudo for that step only).
# Per-user settings are applied with xfconf-query for the invoking user.
#
# License: GPL-3.0+/MIT (same as upstream Win2k / Chicago95)
# ----------------------------------------------------------------------------

set -euo pipefail

# ---------------------------------------------------------------------------
# Paths & constants
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS="$SCRIPT_DIR/assets"

GTK_THEME="Win2K"
GTK_THEME_NL="Win2K_NoLabel"
ICON_THEME="Win2k"
CURSOR_THEME="Win2K_Cursor"
SOUND_THEME="Win2k"
UI_FONT="Tahoma 9"
WM_TITLE_FONT="Tahoma Bold 8"
WALLPAPER="windows2k.png"

BACKUP_DIR="$HOME/.config/win2k_undead"
GTK_USER_CSS="$HOME/.config/gtk-3.0/gtk.css"
CSS_BEGIN="/* >>> win2k_undead xfdesktop fix (do not edit between markers) */"
CSS_END="/* <<< win2k_undead xfdesktop fix */"

# Windows "Command Prompt" terminal look (bash prompt + xfce4-terminal colours)
CMD_PROMPT_DST="$HOME/.config/win2k_undead/cmd-prompt.sh"
BASHRC="$HOME/.bashrc"
BASHRC_BEGIN="# >>> win2k_undead cmd prompt >>>"
BASHRC_END="# <<< win2k_undead cmd prompt <<<"

INSTALL_DEPS=1
INSTALL_PANEL=1
INSTALL_CMD=1

# ---------------------------------------------------------------------------
# Pretty output
# ---------------------------------------------------------------------------
c_blue=$'\e[1;34m'; c_grn=$'\e[1;32m'; c_yel=$'\e[1;33m'; c_red=$'\e[1;31m'; c_rst=$'\e[0m'
say()  { printf '%s==>%s %s\n' "$c_blue" "$c_rst" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$c_grn"  "$c_rst" "$*"; }
warn() { printf '%s  !!%s %s\n' "$c_yel"  "$c_rst" "$*"; }
die()  { printf '%s ERR%s %s\n' "$c_red"  "$c_rst" "$*" >&2; exit 1; }

usage() {
  cat <<EOF
Win2k Undead installer

Usage: ./install.sh [options]

Options:
  --no-deps      Skip the optional pacman dependency step
  --no-panel     Do not build/replace the XFCE panel layout
  --no-cmd       Do not apply the Windows "Command Prompt" terminal look
  -h, --help     Show this help

Run ./uninstall.sh to remove everything this script installs.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-deps)  INSTALL_DEPS=0 ;;
    --no-panel) INSTALL_PANEL=0 ;;
    --no-cmd)   INSTALL_CMD=0 ;;
    -h|--help)  usage; exit 0 ;;
    *) die "Unknown option: $1 (try --help)" ;;
  esac
  shift
done

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
[ "$(id -u)" -ne 0 ] || die "Do not run as root. Run as your normal user; sudo is requested only when needed."
[ -d "$ASSETS" ]     || die "assets/ folder not found next to this script ($ASSETS)."

have() { command -v "$1" >/dev/null 2>&1; }

if ! have xfconf-query; then
  die "xfconf-query not found. This installs an XFCE theme; install XFCE first (e.g. 'sudo pacman -S --needed xfce4')."
fi

if ! have pacman; then
  warn "pacman not found - this is tuned for Arch but assets will still install. Skipping dependency step."
  INSTALL_DEPS=0
fi

say "Win2k Undead :: installing the Windows 2000 look for XFCE"
echo
warn "Heads-up: this uses 'sudo' for two things - installing a couple of small"
warn "packages, and copying theme files into /usr/share. If you typed your"
warn "password recently, sudo stays unlocked for a few minutes and won't ask"
warn "again; that is normal, nothing is happening silently behind your back."
echo

# ---------------------------------------------------------------------------
# 1) Optional dependencies (Arch). Nothing here is destructive.
#    The panel is built with xfconf-query directly, so no extra tools needed.
# ---------------------------------------------------------------------------
if [ "$INSTALL_DEPS" -eq 1 ]; then
  say "Step 1/3 - optional dependencies (pacman)"
  # xfce4-pulseaudio-plugin = the taskbar volume icon (else a "plugin not found"
  # box); adwaita-icon-theme = fallback icons so tray/volume/network aren't blank.
  deps=(xfce4-pulseaudio-plugin adwaita-icon-theme)
  have fc-cache               || deps+=(fontconfig)
  have gtk-update-icon-cache  || deps+=(gtk-update-icon-cache)
  # Network tray icon: add the applet only if NetworkManager is actually in use,
  # so we never pull NetworkManager onto a system that uses something else.
  if command -v nmcli >/dev/null 2>&1 || systemctl is-active --quiet NetworkManager 2>/dev/null; then
    have nm-applet || deps+=(network-manager-applet)
  fi
  if [ "${#deps[@]}" -gt 0 ]; then
    say "Installing: ${deps[*]}  (you may be prompted for your password)"
    if sudo pacman -S --needed --noconfirm "${deps[@]}"; then
      ok "Dependencies installed"
    else
      warn "Could not install ${deps[*]} - continuing (only cache refresh is affected)."
    fi
  else
    ok "All dependencies already present - nothing to install"
  fi
  echo
fi

# ---------------------------------------------------------------------------
# 2) System-wide assets under /usr/share  (sudo)
# ---------------------------------------------------------------------------
say "Step 2/3 - installing assets to /usr/share (sudo required)"

# 2a. GTK / xfwm theme (+ NoLabel taskbar variant)
sudo rm -rf "/usr/share/themes/$GTK_THEME" "/usr/share/themes/$GTK_THEME_NL"
sudo cp -r "$ASSETS/themes/$GTK_THEME" "/usr/share/themes/$GTK_THEME"
sudo cp "$ASSETS/gtk-menu.css" "/usr/share/themes/$GTK_THEME/gtk-3.0/gtk-menu.css"

# NoLabel variant = same theme with the alternate index.theme + xfce.css
sudo cp -r "/usr/share/themes/$GTK_THEME" "/usr/share/themes/$GTK_THEME_NL"
sudo cp "$ASSETS/nolabel/index.theme" "/usr/share/themes/$GTK_THEME_NL/index.theme"
sudo cp "$ASSETS/nolabel/xfce.css"    "/usr/share/themes/$GTK_THEME_NL/gtk-3.0/apps/xfce.css"
ok "GTK/xfwm theme: $GTK_THEME, $GTK_THEME_NL"

# 2b. Icon theme + cursor theme (shipped as tarballs; extracted here)
sudo rm -rf "/usr/share/icons/$ICON_THEME" "/usr/share/icons/$CURSOR_THEME"
sudo tar -xzf "$ASSETS/icons/Win2k.tar.gz"        -C /usr/share/icons/
sudo tar -xzf "$ASSETS/icons/Win2K_Cursor.tar.gz" -C /usr/share/icons/
# The bundled index.theme inherits "hicolor #,WhiteSur,Tela-purple,Numix" - the
# "hicolor #" is malformed and the rest are themes that don't exist here, so any
# icon Win2k lacks (network, volume, tray apps...) renders as a broken square.
# Point the fallback at Adwaita + hicolor, which exist and cover those icons.
sudo sed -i 's/^Inherits=.*/Inherits=Adwaita,hicolor/' "/usr/share/icons/$ICON_THEME/index.theme"
ok "Icon theme: $ICON_THEME (fallback: Adwaita, hicolor)   Cursor theme: $CURSOR_THEME"

# 2c. Fonts (all bundled Windows fonts -> Tahoma is the UI font)
sudo rm -rf /usr/share/fonts/Win2k
sudo mkdir -p /usr/share/fonts/Win2k
sudo cp -r "$ASSETS/fonts/." /usr/share/fonts/Win2k/
ok "Fonts installed to /usr/share/fonts/Win2k"

# 2d. Sound theme
sudo rm -rf "/usr/share/sounds/$SOUND_THEME"
sudo cp -r "$ASSETS/sounds/$SOUND_THEME" "/usr/share/sounds/$SOUND_THEME"
ok "Sound theme: $SOUND_THEME"

# 2e. Wallpapers
sudo mkdir -p /usr/share/backgrounds
sudo cp -f "$ASSETS"/backgrounds/*.png "$ASSETS"/backgrounds/*.jpg /usr/share/backgrounds/ 2>/dev/null || true
[ -d "$ASSETS/backgrounds/xfce" ] && sudo cp -rf "$ASSETS/backgrounds/xfce" /usr/share/backgrounds/
ok "Wallpapers installed to /usr/share/backgrounds"

# 2f. Refresh caches
have gtk-update-icon-cache && sudo gtk-update-icon-cache -f "/usr/share/icons/$ICON_THEME" >/dev/null 2>&1 || true
have fc-cache && sudo fc-cache -f >/dev/null 2>&1 || true
ok "Icon and font caches refreshed"
# The icon fallback points at Adwaita; without it, tray/network/volume icons
# stay blank. Warn loudly if it is missing.
if [ ! -d /usr/share/icons/Adwaita ]; then
  warn "adwaita-icon-theme is NOT installed - tray/volume/network icons will stay"
  warn "blank squares. Install it:  sudo pacman -S adwaita-icon-theme"
fi
echo

# ---------------------------------------------------------------------------
# 3) Per-user configuration (no sudo from here on)
# ---------------------------------------------------------------------------
say "Step 3/3 - applying per-user settings for: $USER"

mkdir -p "$BACKUP_DIR" "$HOME/.config/gtk-3.0"

# 3a. Back up the settings we are about to change, so uninstall can restore.
if [ ! -f "$BACKUP_DIR/xsettings.bak" ]; then
  xfconf-query -c xsettings -lv > "$BACKUP_DIR/xsettings.bak" 2>/dev/null || true
  xfconf-query -c xfwm4    -lv > "$BACKUP_DIR/xfwm4.bak"    2>/dev/null || true
  ok "Backed up current xsettings/xfwm4 to $BACKUP_DIR"
fi

# 3a2. Panel: replace ALL existing panels with the single Win2k taskbar.
#      We write the panel's xfconf XML file directly (the most reliable method
#      across XFCE versions) while the panel AND xfconfd are stopped, so nothing
#      can overwrite it. Done FIRST so stopping xfconfd loses no other setting.
if [ "$INSTALL_PANEL" -eq 1 ]; then
  say "Building the Win2k taskbar (this replaces any existing panels)"
  XFCONF_DIR="$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
  mkdir -p "$XFCONF_DIR" "$HOME/.config/xfce4/panel/launcher-3"
  xfce4-panel --quit >/dev/null 2>&1 || true
  pkill -x xfconfd   >/dev/null 2>&1 || true
  sleep 1
  # Keep a backup of the panel layout we are replacing.
  [ -f "$XFCONF_DIR/xfce4-panel.xml" ] && \
    cp -f "$XFCONF_DIR/xfce4-panel.xml" "$BACKUP_DIR/xfce4-panel.xml.bak" 2>/dev/null || true
  cp -f "$ASSETS/panel/xfce4-panel.xml" "$XFCONF_DIR/xfce4-panel.xml"
  # The "Windows Explorer" quick-launch button (Thunar) used by plugin-3.
  cat > "$HOME/.config/xfce4/panel/launcher-3/thunar.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Windows Explorer
Name[es]=Explorador de Windows
Comment=Browse the filesystem
Exec=thunar %F
Icon=org.xfce.thunar
Terminal=false
StartupNotify=true
EOF
  # Start a fresh panel; xfconfd auto-relaunches and reads our XML.
  if [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
    nohup xfce4-panel >/dev/null 2>&1 &
    disown 2>/dev/null || true
    sleep 1
  fi
  ok "Taskbar installed (Start, Explorer, tasklist, tray, clock)"
fi

# 3b. Theme, icons, cursor, fonts, sounds.
xfconf-query -c xsettings -p /Net/ThemeName          -s "$GTK_THEME"     --create
xfconf-query -c xsettings -p /Net/IconThemeName      -s "$ICON_THEME"    --create
xfconf-query -c xsettings -p /Net/FallbackIconTheme  -s "Adwaita"        --create
xfconf-query -c xsettings -p /Gtk/CursorThemeName    -s "$CURSOR_THEME"  --create
xfconf-query -c xsettings -p /Gtk/FontName           -s "$UI_FONT"       --create
xfconf-query -c xsettings -p /Gtk/MonospaceFontName  -s "$UI_FONT"       --create
xfconf-query -c xsettings -p /Net/SoundThemeName     -s "$SOUND_THEME"   --create
xfconf-query -c xsettings -p /Net/EnableEventSounds  -s true             --create
xfconf-query -c xfwm4     -p /general/theme          -s "$GTK_THEME"     --create
xfconf-query -c xfwm4     -p /general/title_font     -s "$WM_TITLE_FONT" --create
# Win2k look = no transparency / no compositing.
xfconf-query -c xfwm4     -p /general/use_compositing -s false           --create
ok "Theme, icons, cursor, font ($UI_FONT) and sounds applied"

# 3c. Desktop icon view: show launcher icons, hide the default XFCE ones.
xfconf-query -c xfce4-desktop -p /desktop-icons/style                  -s 2     --create
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home       -s false --create
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -s false --create
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable  -s false --create
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash      -s false --create

# 3d. Wallpaper. Must also set image-style: with style 0 (None) the desktop
#     shows a solid colour (black), no matter what last-image points to.
WALL_PATH="/usr/share/backgrounds/$WALLPAPER"
if [ -f "$WALL_PATH" ]; then
  applied=0
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    base="${p%/last-image}"
    xfconf-query -c xfce4-desktop -p "$p"               -s "$WALL_PATH" 2>/dev/null || true
    xfconf-query -c xfce4-desktop -p "$base/image-style" -t int  -s 5    --create 2>/dev/null || true
    xfconf-query -c xfce4-desktop -p "$base/image-show"  -t bool -s true --create 2>/dev/null || true
    applied=1
  done < <(xfconf-query -c xfce4-desktop -l 2>/dev/null | grep '/last-image$' || true)
  if [ "$applied" -eq 0 ]; then
    # No backdrop props yet: create them for the first screen/monitor/workspace.
    base="/backdrop/screen0/monitor0/workspace0"
    xfconf-query -c xfce4-desktop -p "$base/last-image"  -t string -s "$WALL_PATH" --create 2>/dev/null || true
    xfconf-query -c xfce4-desktop -p "$base/image-style" -t int    -s 5            --create 2>/dev/null || true
  fi
  have xfdesktop && (xfdesktop --reload >/dev/null 2>&1 &) || true
  ok "Wallpaper set: $WALLPAPER (zoomed to fill)"
fi

# 3e. XFCE 4.18/4.20 fix: pin desktop-icon label colours via the USER gtk.css.
#     Newer xfdesktop renders labels from the GTK theme; this guarantees the
#     classic blue-selection / white-text Win2k look regardless of version.
tmpcss="$(mktemp)"
if [ -f "$GTK_USER_CSS" ]; then
  # strip any previous block of ours (exact-line match, no regex), keep the rest
  awk -v b="$CSS_BEGIN" -v e="$CSS_END" \
      '$0==b{skip=1} !skip{print} $0==e{skip=0}' "$GTK_USER_CSS" > "$tmpcss"
fi
cat >> "$tmpcss" <<'EOF'
/* >>> win2k_undead xfdesktop fix (do not edit between markers) */
XfdesktopIconView.view {
    background: transparent;
    color: #ffffff;
}
XfdesktopIconView.view .label {
    background-color: transparent;
    color: #ffffff;
    text-shadow: 1px 1px 1px rgba(0,0,0,0.8);
    border-radius: 0;
}
XfdesktopIconView.view:active .label,
XfdesktopIconView.view .label:selected,
XfdesktopIconView.view text:selected {
    background-color: #000080;   /* Win2k selection blue */
    color: #ffffff;
    text-shadow: none;
}
XfdesktopIconView.view .rubberband,
XfdesktopIconView.view rubberband,
.rubberband {
    border: 1px dotted #ff7f7f;
    background-color: rgba(0,0,128,0.25);
}
/* Some client-side-decorated windows/dialogs draw a hard BLACK 1px outline on
   GTK 3.24+/4.20; replace it with the classic Win2k grey (flat, no shadow). */
decoration {
    border-radius: 0;
    box-shadow: 0 0 0 1px #808080;
}
/* <<< win2k_undead xfdesktop fix */
EOF
mv "$tmpcss" "$GTK_USER_CSS"
ok "xfdesktop 4.18/4.20 label fix written to ~/.config/gtk-3.0/gtk.css"

# 3f. Desktop launcher icons (bilingual: locale picks Name vs Name[es]).
DESKTOP_DIR="$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")"
mkdir -p "$DESKTOP_DIR"

write_link() {  # name name_es comment comment_es icon url file
  cat > "$DESKTOP_DIR/$7" <<EOF
[Desktop Entry]
Version=1.0
Type=Link
Name=$1
Name[es]=$2
Comment=$3
Comment[es]=$4
Icon=$5
URL=$6
EOF
  chmod +x "$DESKTOP_DIR/$7"
}
write_app() {   # name name_es comment comment_es icon exec file
  cat > "$DESKTOP_DIR/$7" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$1
Name[es]=$2
Comment=$3
Comment[es]=$4
Icon=$5
Exec=$6
Terminal=false
StartupNotify=false
EOF
  chmod +x "$DESKTOP_DIR/$7"
}

if have thunar; then FM="thunar"; else FM="xdg-open"; fi
write_app  "My Computer" "Mi PC" "View drives and devices" "Ver unidades y dispositivos" \
           "computer" "$FM computer:///" "win2k-computer.desktop"
write_link "My Documents" "Mis documentos" "Your home folder" "Tu carpeta personal" \
           "user-home" "$HOME" "win2k-documents.desktop"
write_link "Recycle Bin" "Papelera de reciclaje" "Deleted items" "Elementos eliminados" \
           "user-trash" "trash:///" "win2k-recyclebin.desktop"
write_link "Local Disk (C:)" "Disco local (C:)" "Filesystem root" "Raíz del sistema de archivos" \
           "drive-harddisk" "file:///" "win2k-localdisk.desktop"
write_app  "Control Panel" "Panel de control" "Settings Manager" "Administrador de configuración" \
           "preferences-system" "xfce4-settings-manager" "win2k-controlpanel.desktop"
write_link "My Network Places" "Mis sitios de red" "Network" "Red" \
           "network-workgroup" "network:///" "win2k-network.desktop"
ok "Desktop icons created in: $DESKTOP_DIR"

# 3g. (The Win2k taskbar is installed earlier in this section - see
#      "Building the Win2k taskbar". It is done first, by writing the panel's
#      xfconf XML directly while the panel + xfconfd are stopped, so it can't be
#      clobbered and stopping xfconfd loses none of the settings below.)

# 3h. Windows "Command Prompt" terminal look (xfce4-terminal + bash prompt).
if [ "$INSTALL_CMD" -eq 1 ]; then
  say "Applying the Command Prompt terminal look"
  # xfce4-terminal colours + DOS font (PxPlus IBM VGA, bundled in the fonts).
  mkdir -p "$HOME/.config/xfce4/terminal"
  cp -f "$ASSETS/cmd/terminalrc" "$HOME/.config/xfce4/terminal/terminalrc"
  # bash prompt (C:\path>): source our snippet from ~/.bashrc, wrapped in markers.
  mkdir -p "$(dirname "$CMD_PROMPT_DST")"
  cp -f "$ASSETS/cmd/cmd-prompt.sh" "$CMD_PROMPT_DST"
  if ! { [ -f "$BASHRC" ] && grep -qF "$BASHRC_BEGIN" "$BASHRC"; }; then
    {
      printf '\n%s\n' "$BASHRC_BEGIN"
      printf '[ -f "%s" ] && . "%s"\n' "$CMD_PROMPT_DST" "$CMD_PROMPT_DST"
      printf '%s\n' "$BASHRC_END"
    } >> "$BASHRC"
  fi
  ok "Command Prompt look applied (terminal + bash prompt; use --no-cmd to skip)"
  echo
fi

# 3i. Network tray icon: start the NetworkManager applet so it appears now (and,
#     since its package ships an autostart entry, on every future login too).
if [ "$INSTALL_PANEL" -eq 1 ] && have nm-applet \
   && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] && ! pgrep -x nm-applet >/dev/null 2>&1; then
  nohup nm-applet >/dev/null 2>&1 &
  disown 2>/dev/null || true
  ok "Started the network tray applet (nm-applet)"
  echo
fi

# 3j. Apply everything LIVE. Rebuilding the panel restarts xfconfd, which can
#     leave xfsettingsd (the daemon that applies theme/icons/cursor/font) showing
#     the old look until the next login. Replace it so the theme, Tahoma font and
#     the fixed icon fallback all take effect right now, without logging out.
if [ -n "${DISPLAY:-}" ]; then
  if have xfsettingsd; then
    nohup xfsettingsd --replace >/dev/null 2>&1 &
    disown 2>/dev/null || true
    sleep 1
  fi
  # Toggle the icon theme so running apps re-read the now-corrected fallback
  # chain (Win2k -> Adwaita -> hicolor) and stop drawing missing icons as boxes.
  xfconf-query -c xsettings -p /Net/IconThemeName -s "hicolor"     2>/dev/null || true
  sleep 1
  xfconf-query -c xsettings -p /Net/IconThemeName -s "$ICON_THEME" 2>/dev/null || true
  have xfdesktop && (xfdesktop --reload >/dev/null 2>&1 &) || true
  ok "Applied theme, font and icons live (no logout needed)"
  echo
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
say "${c_grn}Installation complete.${c_rst}"
cat <<EOF

  Next steps
  ----------
  * Log out and back in so the theme, the taskbar and the Command Prompt
    prompt all take effect cleanly.
  * If event sounds are silent: Settings > Appearance > Settings, sound theme
    "Win2k", and turn system sounds up.
  * Theme is "$GTK_THEME" (Settings > Appearance / Window Manager). An alternate
    "$GTK_THEME_NL" is also installed - both look identical now, pick either.
  * Tray icons (network, volume...) use whatever the Win2k icon theme provides;
    install nm-applet/your tray apps and they will sit in the taskbar tray.

  Nothing here replaced a pacman package or edited os-release, so a normal
  'sudo pacman -Syu' will NOT break this theme.

  To revert everything:  ./uninstall.sh
EOF
