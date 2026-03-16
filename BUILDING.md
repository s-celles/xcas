# Building Xcas

Xcas uses the [Meson](https://mesonbuild.com/) build system.

## Prerequisites

- **Meson** >= 1.2.0 and **Ninja**
- **C/C++ compiler** (GCC >= 7 or Clang)
- **libgiac** — installed with headers and pkg-config file
- **FLTK** >= 1.4.0 (`libfltk1.4-dev` on Debian/Ubuntu, `fltk` on macOS Homebrew, `mingw-w64-x86_64-fltk` on MSYS2)
- Optional: **OpenGL**, **X11**

## Quick Start

```bash
just setup
just build
just run
```

Or without `just`:

```bash
meson setup builddir
meson compile -C builddir
./builddir/src/xcas
```

## Troubleshooting

- **libgiac not found** — set `PKG_CONFIG_PATH` to the directory containing `giac.pc`
- **FLTK not found** — install FLTK 1.4+ for your platform (see above)
- **Missing headers** — ensure libgiac headers are installed to `<prefix>/include/giac/`
