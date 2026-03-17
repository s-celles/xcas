# ── Dependencies for GUI targets ──────────────────────────────────────────────

gui_deps = [giac_dep, giac_extra_inc, fltk_dep] + win_extra_deps
if gl_dep.found()
  gui_deps += gl_dep
endif
if x11_dep.found()
  gui_deps += x11_dep
endif

# ── libxcas (GUI widget library) ─────────────────────────────────────────────

xcas_lib_sources = files(
  'History.cc', 'Input.cc', 'Xcas1.cc', 'Equation.cc',
  'Print.cc', 'Tableur.cc', 'Editeur.cc', 'Graph.cc',
  'Graph3d.cc', 'Help1.cc', 'Cfg.cc',
  'Flv_CStyle.cc', 'Flve_Check_Button.cc', 'Flve_Input.cc',
  'Flv_Style.cc', 'Flv_Data_Source.cc', 'Flve_Combo.cc',
  'Flv_List.cc', 'Flv_Table.cc', 'gl2ps.c', 'Python.cc',
)

libxcas = shared_library('xcas',
  xcas_lib_sources,

  dependencies: gui_deps,
  c_args: xcas_common_args,
  cpp_args: xcas_common_args,
  install: true,
  version: '0.0.0',
  soversion: '0',
)

libxcas_dep = declare_dependency(
  link_with: libxcas,
  dependencies: gui_deps,
)

# ── Install xcas headers (needed by icas for optional GUI support) ────────────

xcas_headers = files(
  'History.h', 'Input.h', 'Xcas1.h', 'Equation.h',
  'Print.h', 'Tableur.h', 'Editeur.h', 'Graph.h',
  'Graph3d.h', 'Help1.h', 'Cfg.h', 'Python.h',
  'Flv_CStyle.H', 'Flv_Data_Source.H', 'Flv_List.H',
  'Flv_Style.H', 'Flv_Table.H',
  'Flve_Check_Button.H', 'Flve_Combo.H', 'Flve_Input.H',
  'Fl_Gl_Choice.H',
  'gl2ps.h', 'hist.h',
)

install_headers(xcas_headers, subdir: 'xcas')

# ── xcas executable ──────────────────────────────────────────────────────────

executable('xcas',
  files('xcas.cxx'),

  dependencies: [giac_dep, libxcas_dep],
  c_args: xcas_common_args,
  cpp_args: xcas_common_args,
  install: true,
)
