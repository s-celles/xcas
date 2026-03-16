# Building Xcas with Meson

This document describes how to build the Xcas graphical CAS frontend using the Meson build system.

## Prerequisites

- **Meson** >= 1.2.0
- **Ninja** (or another Meson backend)
- **C/C++ compiler** (GCC >= 7, Clang)
- **libgiac** — the GIAC CAS library, installed with headers and pkg-config file
- **FLTK** 1.3.x development libraries (required)

### Optional

- **OpenGL** — for 3D graph rendering
- **X11** — for X11 integration on Linux

## Quick Start

```bash
# 1. Install libgiac first (from the giac repo)
cd /path/to/giac
meson setup builddir
meson compile -C builddir
meson install -C builddir

# 2. Build xcas
cd /path/to/xcas
meson setup builddir
meson compile -C builddir
./builddir/src/xcas
```

## Installing Prerequisites

### Debian / Ubuntu

```bash
# Install FLTK
sudo apt install libfltk1.3-dev

# libgiac must be installed from source (see giac repo)
```

### Fedora / RHEL

```bash
sudo dnf install fltk-devel
```

### macOS (Homebrew)

```bash
brew install fltk@1.3
```

**Note**: Xcas requires FLTK 1.3.x. FLTK 1.4+ is not yet supported. On macOS, `fltk@1.3` is keg-only — the build system auto-detects it from Homebrew paths.

### Windows (MSYS2 / MinGW)

```bash
pacman -S mingw-w64-x86_64-fltk
```

## Build Targets

| Target | Type | Description |
|--------|------|-------------|
| libxcas | shared | FLTK GUI widget library |
| xcas | executable | Graphical CAS application |

## Build Options

Xcas currently has no user-facing build options beyond the standard Meson options (`buildtype`, `prefix`, etc.).

## Troubleshooting

### libgiac not found

Ensure libgiac is installed and its pkg-config file is available:

```bash
pkg-config --modversion giac
```

If not found, set `PKG_CONFIG_PATH` to the directory containing `giac.pc`:

```bash
PKG_CONFIG_PATH=/path/to/giac/builddir/meson-private meson setup builddir
```

### FLTK not found

Install FLTK 1.3 development packages for your platform (see above).

On macOS with Homebrew, if `fltk@1.3` is not detected, verify it's installed:

```bash
brew list fltk@1.3
/opt/homebrew/opt/fltk@1.3/bin/fltk-config --version
```

### FLTK 1.4 detected

Xcas requires FLTK 1.3.x. If FLTK 1.4 is detected, install 1.3 alongside it:

```bash
# macOS
brew install fltk@1.3

# The build system prefers fltk@1.3 when both are present
```

### Header not found errors

Xcas GUI sources use bare includes (e.g., `#include "first.h"`) for libgiac headers. The build system adds the `giac/` include subdirectory automatically. If you see missing header errors, ensure libgiac headers are installed to `<prefix>/include/giac/`.
