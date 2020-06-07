valadoc = find_program ('valadoc', required: false)

if (valadoc.found ())
  message ('found valadoc')
  libvqdrdocs = run_target(
    'libvqdrdocs',
    command: [
      valadoc,
      '--directory='+meson.current_build_dir() + 'libvqdr',
      '--basedir='+meson.source_root(),
      '--package-name=libvqdr',
      '--package-version='+meson.project_version(),
      '--pkg=glib-2.0',
      '--pkg=gio-2.0',
      '--pkg=gobject-2.0',
      '--pkg=gee-0.8',
      '--importdir='+join_paths(glib_dep.get_pkgconfig_variable('prefix'), get_option('datadir'), 'gtk-doc', 'html'),
      '--force',
      libvqdr_source_files])
  
endif
