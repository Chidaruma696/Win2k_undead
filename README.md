[🇬🇧 English](README.en.md)

<div align="center">
  <br/>
  <img src="logo.png" width="220" alt="Win2k Undead" />

# Win2k Undead

**復活 · El escritorio de Windows 2000, resucitado para XFCE en cualquier distro.**

<br/>

![XFCE 4.18 / 4.20](https://img.shields.io/badge/xfce-4.18%20%2F%204.20-2284f2?style=for-the-badge&logo=xfce&logoColor=white)
![Arch](https://img.shields.io/badge/arch-1793d1?style=for-the-badge&logo=archlinux&logoColor=white)
![Debian](https://img.shields.io/badge/debian-a81d33?style=for-the-badge&logo=debian&logoColor=white)
![Ubuntu / Mint](https://img.shields.io/badge/ubuntu%20%2F%20mint-e95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Fedora](https://img.shields.io/badge/fedora-51a2da?style=for-the-badge&logo=fedora&logoColor=white)
![Void](https://img.shields.io/badge/void-478061?style=for-the-badge&logo=voidlinux&logoColor=white)
![Licencia GPL-3.0](https://img.shields.io/badge/licencia-GPL--3.0-1b150d?style=for-the-badge)

<br/>

*Solo apariencia · sin paquetes empaquetados · sobrevive a las actualizaciones · se desinstala limpio*

<br/>

<img src="d12.png" width="720" alt="Escritorio Win2k Undead" />
<br/><br/>
<img src="d22.png" width="720" alt="Escritorio Win2k Undead con ventanas" />

</div>

---

> [!NOTE]
> Este es un fork del tema **Win2k** para XFCE, que a su vez es una reinterpretación de **Chicago95**. El arte es de ellos. Lo que cambia aquí es el instalador: uno solo, nativo de cada distro, que no toca nada del sistema y que se puede revertir con un comando.

<br/>

## 🖥️ Qué es

Win2k Undead convierte un escritorio XFCE en un Windows 2000 creíble: tema de ventanas GTK2/GTK3/xfwm4, iconos, cursores, fuentes de Windows con Tahoma como fuente de interfaz, sonidos de eventos, fondos de pantalla, la barra de tareas clásica con menú Inicio, los iconos de escritorio de siempre y hasta una terminal que parece el `cmd`.

El proyecto original hacía todo eso a base de paquetes `.deb` parcheados, purgando paquetes de Mint y sobrescribiendo `os-release`; solo funcionaba en Debian y Mint con XFCE 4.12 a 4.16. Este fork tira todo eso y se queda con lo que importa:

| 📦 `Win2k` original | 🧟 Win2k Undead |
| --- | --- |
| `dpkg`/`apt` con 1,8 GB de `.deb` incluidos | **Ninguno**. Solo recursos visuales; las pocas dependencias opcionales salen de **tu** gestor de paquetes |
| Sobrescribía `/usr/lib/os-release` y `/etc/lsb-release` | **No se tocan.** Una actualización del sistema no rompe nada |
| Purgaba paquetes de Mint e instalaba `.deb` de sistema | **No purga ni reemplaza nada** |
| Debian y Mint, XFCE 4.12 a 4.16 ("4.18 no soportado") | **Arch, Debian, Ubuntu, Mint, Fedora, Void y openSUSE** con XFCE 4.18 y 4.20 |
| `cmd`, `taskmgr` falsos, Wine, IE, WMP10, juegos | **Fuera.** Solo apariencia |
| Inglés y griego | **Inglés y español**, según el idioma de tu sesión |

<br/>

## 🎁 Qué incluye

- 🪟 Tema de ventanas **`Win2K`** para GTK3, GTK2 y xfwm4, más la variante **`Win2K_NoLabel`** para la barra de tareas
- 🖱️ Tema de iconos **`Win2k`** y de cursores **`Win2K_Cursor`**, con Adwaita como respaldo para que nada quede en blanco
- 🔤 Las fuentes de Windows: **Tahoma 9** en la interfaz, Tahoma Bold 8 en los títulos, PxPlus IBM VGA en la terminal
- 🔊 Tema de sonidos de eventos **`Win2k`**: inicio, apagado, error, papelera
- 🏞️ Fondos de pantalla de Windows 2000, incluido el azul clásico
- 🧭 **Barra de tareas** con menú Inicio, acceso al Explorador, lista de ventanas, bandeja con red y volumen, y reloj
- 🗂️ Iconos de escritorio: *Mi PC, Mis documentos, Papelera de reciclaje, Disco local (C:), Panel de control, Mis sitios de red*, enlazados a Thunar, la papelera y la configuración reales
- ⌨️ **Símbolo del sistema**: bash con prompt `C:\Users\tú>`, el banner de Windows 2000 y xfce4-terminal en negro con fuente DOS

<br/>

## 🐧 Distros

El instalador lee `/etc/os-release`, elige el gestor de paquetes y solo lo usa para tres o cuatro paquetes opcionales. Todo lo demás son archivos bajo `/usr/share` y ajustes de `xfconf`, idénticos en cualquier distro.

| Distro | Gestor | Qué instala si falta |
| --- | --- | --- |
| Arch, Manjaro, EndeavourOS, Artix, CachyOS | `pacman` | `xfce4-pulseaudio-plugin`, `adwaita-icon-theme`, `fontconfig`, `gtk-update-icon-cache`, `network-manager-applet` |
| Debian, Ubuntu, Linux Mint, Pop!_OS, Zorin, elementary | `apt` | `xfce4-pulseaudio-plugin`, `adwaita-icon-theme`, `fontconfig`, `gtk-update-icon-cache`, `network-manager-gnome` |
| Fedora, Nobara, RHEL y derivadas | `dnf` | `xfce4-pulseaudio-plugin`, `adwaita-icon-theme`, `fontconfig`, `gtk-update-icon-cache`, `network-manager-applet` |
| Void Linux | `xbps` | `xfce4-pulseaudio-plugin`, `adwaita-icon-theme`, `fontconfig`, `gtk-update-icon-cache`, `network-manager-applet` |
| openSUSE Tumbleweed y Leap | `zypper` | `xfce4-panel-plugin-pulseaudio`, `adwaita-icon-theme`, `fontconfig`, `gtk3-tools`, `NetworkManager-applet` |

El applet de red solo se instala si NetworkManager está en uso; si tu sistema usa otra cosa, no se te cuela nada. En una distro que no esté en la lista el tema se instala igual y solo se salta ese paso.

<br/>

## 📲 Instalación

Necesitas XFCE ya instalado (el grupo `xfce4` de tu distro) y una sesión abierta en él.

```bash
git clone https://github.com/Chidaruma696/Win2k_undead.git
cd Win2k_undead
chmod +x install.sh uninstall.sh
./install.sh
```

Ejecútalo con tu usuario normal. Pide `sudo` solo para dos cosas: instalar esos paquetes opcionales y copiar los recursos a `/usr/share`. El tema, la fuente y los iconos se aplican en vivo; cierra sesión y vuelve a entrar para que la barra de tareas y el prompt queden perfectos.

| Opción | Efecto |
| --- | --- |
| `--no-deps` | No instala nada con el gestor de paquetes |
| `--no-panel` | Conserva tu barra de tareas actual en vez de reemplazarla |
| `--no-cmd` | Conserva tu terminal y tu prompt de bash |
| `--help` | Muestra la ayuda |

### Desinstalación

```bash
./uninstall.sh
```

Borra los recursos de `/usr/share`, los iconos de escritorio, el bloque de CSS y el del prompt, restaura la barra por defecto de XFCE y devuelve el tema a Adwaita. Solo elimina lo que este proyecto creó; los paquetes que instaló se quedan, porque son paquetes normales de tu distro. Tu configuración previa queda guardada en `~/.config/win2k_undead` por si quieres consultarla.

<br/>

## 🔧 Cómo funciona

```
Win2k_undead/
├── install.sh           Detecta la distro, copia recursos a /usr/share y configura tu usuario
├── uninstall.sh         Revierte todo lo anterior
└── assets/
    ├── themes/Win2K/     Tema GTK2 / GTK3 / xfwm4
    ├── icons/            Win2k y Win2K_Cursor (tarballs, se extraen al instalar)
    ├── fonts/            Fuentes de Windows
    ├── sounds/Win2k/     Tema de sonidos
    ├── backgrounds/      Fondos de pantalla
    ├── panel/            Diseño de la barra de tareas (XML de xfconf)
    ├── cmd/              terminalrc y el prompt C:\> para bash
    ├── nolabel/          Variante Win2K_NoLabel
    ├── xfconf/           XML de referencia de los canales de XFCE
    └── gtk-menu.css      Estilo de menús que se fusiona con el tema
```

El instalador hace tres cosas, en este orden:

1. **Dependencias opcionales** con el gestor de tu distro. Nada destructivo: solo el plugin de volumen, Adwaita como respaldo de iconos y, si aplica, el applet de red.
2. **Recursos del sistema** bajo `/usr/share`: tema, iconos, cursores, fuentes, sonidos y fondos. Corrige de paso el `index.theme` de los iconos, que apuntaba a temas inexistentes y dejaba la bandeja llena de cuadros rotos.
3. **Tu usuario**, sin `sudo`: escribe el XML de la barra de tareas con el panel y `xfconfd` parados para que nadie lo pise, aplica tema, fuente, cursor y sonidos con `xfconf-query`, crea los iconos de escritorio bilingües, añade a `~/.config/gtk-3.0/gtk.css` el bloque que arregla las etiquetas de iconos en XFCE 4.18 y 4.20, instala el look de `cmd` y reinicia `xfsettingsd` para que todo se vea al instante.

Todo lo que toca en tu carpeta personal va entre marcadores (`>>> win2k_undead ... <<<`), así el desinstalador quita exactamente eso y deja el resto de tu `gtk.css` y tu `.bashrc` como estaban.

<br/>

## ❓ Notas

- **¿Sin sonidos?** Configuración ▸ Apariencia ▸ Ajustes, tema de sonido `Win2k`, y sube el volumen de *Sonidos del sistema*.
- **¿Iconos de bandeja en blanco?** Falta `adwaita-icon-theme`. El instalador avisa y te dice el comando exacto para tu distro.
- **¿Etiquetas de iconos raras en 4.20?** El bloque de `gtk.css` fuerza la selección azul con texto blanco de Windows 2000. Puedes cambiar los colores ahí.
- **¿Compositor?** No hace falta, y el look Win2k lo desactiva. Si lo quieres, actívalo en Ajustes del gestor de ventanas.
- **¿Otra barra?** Instala con `--no-panel`. El XML de referencia queda en `assets/panel` por si quieres copiar solo partes.
- **¿Void sin systemd?** Funciona: la detección de NetworkManager mira el proceso, no `systemctl`.

<br/>

## 🙏 Créditos y licencia

- El arte y los sonidos son del proyecto **Win2k** de et0ndyy, construido sobre **Chicago95** de Grassmunk, AdrianoML y EMH-Mark-I.
- Este fork solo reescribe el instalador para XFCE moderno y varias distros; los recursos visuales no cambian.
- Licencia **[GPL-3.0](LICENSE)**, la misma del proyecto original. Las fuentes de Windows incluidas conservan sus propias condiciones.

<br/>

<div align="center">

*It's now safe to turn off your computer.*

復活 · ふっかつ

</div>
