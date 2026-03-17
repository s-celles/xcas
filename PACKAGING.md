# Packaging Xcas

Xcas depends on [libgiac](https://github.com/s-celles/giac). Both use Meson.

## Debian/Ubuntu (.deb)

Create a `debian/` directory with:

- **`control`** — declares `Build-Depends` (meson, ninja-build, libgmp-dev, libmpfr-dev, libfltk1.4-dev, libgiac-dev) and `Depends` (`${shlibs:Depends}` auto-detects libgiac)
- **`rules`** — minimal Meson build:
  ```makefile
  #!/usr/bin/make -f
  %:
  	dh $@
  override_dh_auto_configure:
  	dh_auto_configure --buildsystem=meson
  ```
- **`changelog`**, **`copyright`**, **`source/format`** (`3.0 (quilt)`)

Build with: `dpkg-buildpackage -us -uc`

## Homebrew (macOS)

Create a tap `homebrew-giac/` with `Formula/xcas.rb`:

```ruby
class Xcas < Formula
  desc "Computer algebra system GUI"
  homepage "https://github.com/s-celles/xcas"
  url "https://github.com/s-celles/xcas/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "..."
  license "GPL-3.0-or-later"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "s-celles/giac/giac"
  depends_on "fltk"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end
end
```

Install with: `brew tap s-celles/giac && brew install xcas`

## MSYS2 (Windows)

Create a `PKGBUILD`:

```bash
_realname=xcas
pkgbase=mingw-w64-${_realname}
pkgname="${MINGW_PACKAGE_PREFIX}-${_realname}"
pkgver=1.0.0
pkgrel=1
pkgdesc="Computer algebra system GUI"
arch=('any')
license=('GPL3')
depends=("${MINGW_PACKAGE_PREFIX}-giac"
         "${MINGW_PACKAGE_PREFIX}-fltk"
         "${MINGW_PACKAGE_PREFIX}-gmp"
         "${MINGW_PACKAGE_PREFIX}-mpfr")
makedepends=("${MINGW_PACKAGE_PREFIX}-meson"
             "${MINGW_PACKAGE_PREFIX}-ninja"
             "${MINGW_PACKAGE_PREFIX}-cc")
source=("https://github.com/s-celles/xcas/archive/v${pkgver}.tar.gz")

build() {
  ${MINGW_PREFIX}/bin/meson setup \
    --prefix="${MINGW_PREFIX}" \
    --buildtype=release \
    "${_realname}-${pkgver}" build-${MSYSTEM}
  ${MINGW_PREFIX}/bin/meson compile -C build-${MSYSTEM}
}

package() {
  ${MINGW_PREFIX}/bin/meson install -C build-${MSYSTEM} \
    --destdir "${pkgdir}"
}
```

Build with: `MINGW_ARCH=ucrt64 makepkg-mingw -sLf`

## Conda-forge

Create a feedstock with `recipe/meta.yaml`:

```yaml
package:
  name: xcas
  version: "1.0.0"

source:
  url: https://github.com/s-celles/xcas/archive/v1.0.0.tar.gz
  sha256: "..."

requirements:
  build:
    - {{ compiler('cxx') }}
    - meson
    - ninja
    - pkg-config
  host:
    - giac
    - fltk
    - gmp
    - mpfr
  run:
    - giac
    - fltk
```

Build script (`build.sh`):
```bash
meson setup builddir --prefix=$PREFIX
meson compile -C builddir
meson install -C builddir
```

Submit via PR to [conda-forge/staged-recipes](https://github.com/conda-forge/staged-recipes).

## AppImage (Linux portable)

```bash
meson install -C builddir --destdir AppDir
linuxdeploy --appdir AppDir \
  --executable AppDir/usr/local/bin/xcas \
  --desktop-file xcas.desktop \
  --icon-file xcas.xpm \
  --output appimage
```

`linuxdeploy` bundles libgiac and other shared libraries automatically.

## Summary

| Method | Platform | Key file | libgiac dependency |
|--------|----------|----------|--------------------|
| dpkg | Debian/Ubuntu | `debian/control` | `${shlibs:Depends}` (auto) |
| Homebrew | macOS | `Formula/xcas.rb` | `depends_on "giac"` |
| MSYS2 | Windows | `PKGBUILD` | `depends=(mingw-w64-...-giac)` |
| Conda-forge | All | `recipe/meta.yaml` | `run: giac` |
| AppImage | Linux | `linuxdeploy` | Bundled inside |
