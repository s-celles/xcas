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

# GMP and MPFR (required — giac's .pc file may not list them as public deps)
gmp_dep = dependency('gmp', required: true)
mpfr_dep = dependency('mpfr', required: true)

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

# FLTK (required — GUI framework)
# Try system FLTK via fltk-config
fltk_dep = dependency('fltk', method: 'config-tool', required: false)

# If config-tool method failed, try explicit fltk-config paths
if not fltk_dep.found()
  _fltk_search_paths = []
  if host_machine.system() == 'darwin'
    # Homebrew's fltk@1.3 is keg-only
    _fltk_search_paths = ['/opt/homebrew/opt/fltk@1.3/bin/fltk-config',
                          '/usr/local/opt/fltk@1.3/bin/fltk-config']
  else
    _fltk_search_paths = ['/usr/bin/fltk-config']
  endif

  foreach _fltk13_path : _fltk_search_paths
    _fltk13 = find_program(_fltk13_path, required: false)
    if _fltk13.found()
      _fltk_cflags = run_command(_fltk13, '--cflags', check: true).stdout().strip()
      _fltk_ldflags = run_command(_fltk13, '--use-gl', '--use-images', '--ldflags',
        check: true).stdout().strip()
      _fltk_ver = run_command(_fltk13, '--version', check: true).stdout().strip()
      _fltk_link_args = []
      foreach _f : _fltk_ldflags.split()
        if _f != '-lpng' and _f != '-ljpeg'
          _fltk_link_args += _f
        endif
      endforeach
      _fltk_img_deps = [
        dependency('libpng', required: false),
        dependency('libjpeg', required: false),
      ]
      fltk_dep = declare_dependency(
        compile_args: _fltk_cflags.split(),
        link_args: _fltk_link_args,
        dependencies: _fltk_img_deps,
        version: _fltk_ver,
      )
      break
    endif
  endforeach
endif

if not fltk_dep.found()
  fltk_dep = dependency('fltk', required: true)
endif

# Warn if FLTK 1.4 is found — xcas GUI requires 1.3.x
if fltk_dep.version().version_compare('>= 1.4.0')
  warning('FLTK ' + fltk_dep.version() + ' detected but xcas requires FLTK 1.3.x. ' +
          'On macOS: brew install fltk@1.3')
endif

# Optional GL and X11
gl_dep = dependency('gl', required: false)
x11_dep = dependency('x11', required: false)

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
