project('xcas', 'c', 'cpp',
  version: '1.0.0',
  meson_version: '>= 1.2.0',
  license: 'GPL-3.0-or-later',
  default_options: [
    'cpp_std=c++14',
    'warning_level=1',
  ],
)

cc = meson.get_compiler('c')
cxx = meson.get_compiler('cpp')

# ── Dependencies ──────────────────────────────────────────────────────────────

# libgiac (required — core CAS library)
giac_dep = dependency('giac', required: true)

# giac headers are installed to <prefix>/include/giac/ but xcas sources
# use bare includes (#include "first.h" not "giac/first.h").
# Add the giac subdirectory to the include path.
giac_includedir = giac_dep.get_variable(pkgconfig: 'includedir', default_value: '')
if giac_includedir != ''
  giac_extra_inc = declare_dependency(
    compile_args: ['-I' + giac_includedir / 'giac'],
  )
else
  giac_extra_inc = declare_dependency()
endif

# FLTK (required — GUI framework, >= 1.4.0)
# Try config-tool first, then pkg-config/cmake as fallback
fltk_dep = dependency('fltk', method: 'config-tool', required: false)
if not fltk_dep.found()
  fltk_dep = dependency('fltk', required: false)
endif
if not fltk_dep.found()
  error('FLTK >= 1.4.0 is required but was not found. ' +
        'Install: apt install libfltk1.4-dev (Debian/Ubuntu), ' +
        'brew install fltk (macOS), ' +
        'pacman -S mingw-w64-x86_64-fltk (MSYS2)')
endif
# Verify version if available (CMake detection may report 'unknown')
if fltk_dep.version() != 'unknown' and fltk_dep.version().version_compare('< 1.4.0')
  error('FLTK >= 1.4.0 is required but found ' + fltk_dep.version() + '. ' +
        'Please upgrade your FLTK installation.')
endif

# Optional GL and X11
gl_dep = dependency('gl', required: false)
x11_dep = dependency('x11', required: false)

# Windows-specific dependencies
if host_machine.system() == 'windows'
  intl_dep = cc.find_library('intl', required: true)
  win_extra_deps = [intl_dep]
else
  win_extra_deps = []
endif

# ── Common compile arguments ──────────────────────────────────────────────────

xcas_common_args = [
  '-DHAVE_CONFIG_H',
  '-DHAVE_LIBFLTK',
  '-fno-strict-aliasing',
]

if host_machine.system() == 'windows'
  xcas_common_args += ['-DWIN32']
endif

if gl_dep.found()
  xcas_common_args += ['-DHAVE_LIBGL', '-DHAVE_LIBFLTK_GL']
endif

# ── Build ─────────────────────────────────────────────────────────────────────

subdir('src')

# ── Summary ───────────────────────────────────────────────────────────────────

summary({
  'libgiac': giac_dep.version(),
  'FLTK': fltk_dep.version(),
  'OpenGL': gl_dep.found(),
}, section: 'Dependencies', bool_yn: true)
