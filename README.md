<h1 align="center">Win2k Undead</h1>
<p align="center"><b>Windows 2000 look &amp; feel for XFCE — resurrected for Arch Linux.</b></p>
<p align="center"><img src="logo.png" alt="Win2k Undead"/></p>

A modernized, **appearance-only** fork of the original `Win2k` total conversion,
rebuilt to run on **Arch Linux** and **XFCE 4.18 / 4.20** — with no Debian
baggage and nothing that a `pacman -Syu` can break.

> The original theming is a Windows 2000 reskin of **Chicago95** (by Grassmunk
> et al.). This fork keeps those visual assets and replaces the Debian-only
> installer with a clean, update-safe, Arch-native one.

### Screenshots
<p align="center">
<img src="d12.png" alt="Desktop"/>
<img src="d22.png" alt="Desktop"/>
</p>

---

## 🇬🇧 English

### What changed vs. the original

| Original `Win2k` (Debian/Mint) | Win2k Undead (Arch) |
| --- | --- |
| `dpkg`/`apt` + ~1.8 GB of bundled `.deb` packages | **None** — uses your Arch packages; ships only visual assets |
| Overwrote `/usr/lib/os-release` & `/etc/lsb-release` | **Never touched** — survives system updates |
| Purged Mint theme packages, installed patched system `.deb`s | **Nothing purged or replaced** |
| Targeted XFCE 4.12–4.16 (*"4.18 Not Supported"*) | **Supports XFCE 4.18 / 4.20** (the desktop-icon rendering change is handled) |
| Fake `cmd`/`taskmgr`, Wine, IE, WMP10, games, renames | **Dropped** — appearance only |
| English / Greek | **English / Spanish** (locale-aware desktop icons) |

### What you get

- GTK3 + GTK2 + xfwm4 window theme **`Win2K`** (and **`Win2K_NoLabel`** taskbar variant)
- **`Win2k`** icon theme and **`Win2K_Cursor`** cursor theme
- Windows fonts (UI font = **Tahoma 9**)
- **`Win2k`** event sound theme
- Windows 2000 wallpapers
- Classic **Start menu + taskbar** panel layout
- Desktop icons: *My Computer, My Documents, Recycle Bin, Local Disk (C:),
  Control Panel, My Network Places* — wired to native targets (Thunar, trash, etc.)

### Requirements

- Arch Linux (or derivative) with **XFCE** installed (`sudo pacman -S --needed xfce4 xfce4-goodies`)
- Optional, auto-installed if missing: `fontconfig`, `gtk-update-icon-cache`
- For tray icons in the taskbar, install your tray apps (e.g. `network-manager-applet`)
- A compositor is **not** required (the Win2k look disables compositing)
- No `xfce4-panel-profiles` needed — the taskbar is built directly with `xfconf-query`

### Install

```bash
git clone https://github.com/Chidaruma696/Win2k_undead.git
cd Win2k_undead
chmod +x install.sh uninstall.sh
./install.sh
```

Then **log out and back in**. Run as your normal user — the script asks for
`sudo` only to copy assets into `/usr/share`.

Options: `--no-deps` (skip pacman), `--no-panel` (keep your current panel),
`--no-cmd` (keep your normal terminal/prompt), `--help`.

### Uninstall

```bash
./uninstall.sh
```

Removes the installed assets, the desktop icons and the user CSS fix, and resets
the theme to defaults. It only deletes files this project created.

### Notes

- **No event sounds?** Settings ▸ Appearance ▸ Settings → sound theme `Win2k`,
  then raise the *System sounds* volume.
- **Taskbar:** built directly with `xfconf-query` (no extra tools) — bottom panel
  with Start menu, Explorer launcher, tasklist, notification tray and clock. It
  *replaces* your current panel; keep yours with `./install.sh --no-panel`.
- **Command Prompt look:** bash gets a `C:\>` prompt and xfce4-terminal a DOS
  font (PxPlus IBM VGA) + black palette. Opt out with `./install.sh --no-cmd`.
- **Tray icons** (network, volume…) use whatever the Win2k icon theme provides
  for the standard icon names; the panel just gives them a home.
- **Desktop-icon labels look wrong on 4.20?** The installer writes an
  `XfdesktopIconView` block into `~/.config/gtk-3.0/gtk.css` to force the
  classic blue-selection / white-text look. Edit the colours there if desired.

---

## 🇪🇸 Español

### Qué cambia respecto al original

| `Win2k` original (Debian/Mint) | Win2k Undead (Arch) |
| --- | --- |
| `dpkg`/`apt` + ~1.8 GB de `.deb` incluidos | **Ninguno** — usa tus paquetes de Arch; solo trae los recursos visuales |
| Sobrescribía `/usr/lib/os-release` y `/etc/lsb-release` | **No se tocan** — sobrevive a las actualizaciones |
| Purgaba paquetes de Mint e instalaba `.deb` de sistema parcheados | **No purga ni reemplaza nada** |
| Para XFCE 4.12–4.16 (*"4.18 no soportado"*) | **Compatible con XFCE 4.18 / 4.20** (se gestiona el cambio de render de iconos) |
| `cmd`/`taskmgr` falsos, Wine, IE, WMP10, juegos, renombrados | **Eliminados** — solo apariencia |
| Inglés / Griego | **Inglés / Español** (iconos de escritorio según tu idioma) |

### Qué incluye

- Tema de ventanas GTK3 + GTK2 + xfwm4 **`Win2K`** (y la variante **`Win2K_NoLabel`**)
- Tema de iconos **`Win2k`** y de cursores **`Win2K_Cursor`**
- Fuentes de Windows (fuente de interfaz = **Tahoma 9**)
- Tema de sonidos de eventos **`Win2k`**
- Fondos de Windows 2000
- Distribución de panel clásica con **menú Inicio + barra de tareas**
- Iconos de escritorio: *Mi PC, Mis documentos, Papelera de reciclaje,
  Disco local (C:), Panel de control, Mis sitios de red* — enlazados a
  destinos nativos (Thunar, papelera, etc.)

### Requisitos

- Arch Linux (o derivada) con **XFCE** instalado (`sudo pacman -S --needed xfce4 xfce4-goodies`)
- Opcionales, se instalan solos si faltan: `fontconfig`, `gtk-update-icon-cache`
- Para los iconos de la bandeja, instala tus apps de bandeja (p. ej. `network-manager-applet`)
- **No** hace falta compositor (el look Win2k desactiva el compositing)
- **No** necesita `xfce4-panel-profiles` — la barra se crea directo con `xfconf-query`

### Instalación

```bash
git clone https://github.com/Chidaruma696/Win2k_undead.git
cd Win2k_undead
chmod +x install.sh uninstall.sh
./install.sh
```

Después **cierra sesión y vuelve a entrar**. Ejecútalo como tu usuario normal —
el script pide `sudo` solo para copiar los recursos a `/usr/share`.

Opciones: `--no-deps` (omite pacman), `--no-panel` (conserva tu panel actual),
`--no-cmd` (conserva tu terminal/prompt normal), `--help`.

### Desinstalación

```bash
./uninstall.sh
```

Quita los recursos instalados, los iconos de escritorio y el arreglo de CSS, y
restablece el tema por defecto. Solo borra lo que este proyecto creó.

### Notas

- **¿Sin sonidos de eventos?** Configuración ▸ Apariencia ▸ Ajustes → tema de
  sonido `Win2k`, y sube el volumen de *Sonidos del sistema*.
- **Barra de tareas:** se crea directo con `xfconf-query` (sin herramientas extra):
  panel inferior con menú Inicio, lanzador de Explorer, lista de tareas, bandeja
  y reloj. *Reemplaza* tu panel actual; consérvalo con `./install.sh --no-panel`.
- **Look de cmd:** bash recibe un prompt `C:\>` y xfce4-terminal una fuente DOS
  (PxPlus IBM VGA) + paleta negra. Desactívalo con `./install.sh --no-cmd`.
- **Iconos de bandeja** (red, volumen…) usan lo que provea el tema de iconos
  Win2k para los nombres estándar; el panel solo les da un sitio.
- **¿Etiquetas de iconos raras en 4.20?** El instalador añade un bloque
  `XfdesktopIconView` a `~/.config/gtk-3.0/gtk.css` para forzar el look clásico
  (selección azul / texto blanco). Cambia ahí los colores si quieres.

---

## Layout

```
Win2k_undead/
├── install.sh           Arch installer (system assets + per-user config)
├── uninstall.sh         Clean revert
├── README.md            This file
├── LICENSE              GPL-3.0
└── assets/
    ├── themes/Win2K/     GTK2/GTK3/xfwm4 window theme
    ├── icons/            Win2k + Win2K_Cursor (tarballs, extracted on install)
    ├── fonts/            Windows fonts (Tahoma is the UI font)
    ├── sounds/Win2k/     Event sound theme
    ├── backgrounds/      Wallpapers
    ├── cmd/              Command Prompt look (terminalrc + bash C:\> prompt)
    ├── panel/            reference panel profile (taskbar is built via xfconf)
    ├── xfconf/           Reference XFCE channel XML (not blindly applied)
    ├── nolabel/          Assets for the Win2K_NoLabel variant
    └── gtk-menu.css      Menu styling merged into the theme
```

## Credits & License

- Visual assets: **Win2k** project, built on **Chicago95** by Grassmunk,
  AdrianoML and EMH-Mark-I.
- License: **[GPL-3.0+](LICENSE) / MIT** (same as upstream).
- This fork only rewrites the installer/packaging for Arch + modern XFCE; the
  artwork is unchanged.
