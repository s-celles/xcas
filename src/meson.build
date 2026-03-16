# ── Dependencies for GUI targets ──────────────────────────────────────────────

gui_deps = [giac_dep, fltk_dep]
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

# ── xcas executable ──────────────────────────────────────────────────────────

executable('xcas',
  files('xcas.cxx'),
  dependencies: [giac_dep, libxcas_dep],
  c_args: xcas_common_args,
  cpp_args: xcas_common_args,
  install: true,
)
