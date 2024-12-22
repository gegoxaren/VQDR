project('vqdr', ['c', 'vala'], 
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                     'c_std=c11',
                   ],
)
cc = meson.get_compiler ('c')
valac = meson.get_compiler ('vala')

conf = configuration_data()

add_project_arguments(['--abi-stability', '--vapi-comments'], language: 'vala')

libvqdr_dependencies = []
libvee_dependencies = []

glib_dep = dependency ('glib-2.0', required : true)
gobject_dep = dependency ('gobject-2.0', required : true)
gee_dep = dependency ('gee-0.8', required : true)
gio_dep = dependency ('gio-2.0', required : true)
gmodule_dep = dependency ('gmodule-2.0', required : true)
posix_dep = valac.find_library ('posix', required : true)
m_dep = cc.find_library('m', required : true)


libvqdr_dependencies += [
  glib_dep,
  gobject_dep,
  gee_dep,
  gio_dep,
  gmodule_dep,
  posix_dep,
  m_dep,
]

libvee_dependencies += [
  glib_dep,
  gobject_dep,
  posix_dep,
  m_dep,
]

subdir('src')

libvee = library ('vee',
                  libvee_source_files,
                  vala_header: 'libvee.h',
                  vala_vapi: 'libvee-0.1.vapi',
                  vala_gir: 'libvee-0.1.gir',
                  dependencies: libvee_dependencies,
                  install: true,
                  install_dir: [true, true, true, true])

libvee_dep = declare_dependency (link_with: libvee,
                                include_directories : include_directories('.'))
                                

libvqdr_dependencies += libvee_dep

libvqdr = library ('vqdr',
                   libvqdr_source_files,
                   link_with : libvee,
                   vala_header: 'libvqdr.h',
                   vala_gir: 'libvqdr-0.1.gir',
                   vala_vapi: 'libvqdr-0.1.vapi',
                   dependencies: libvqdr_dependencies,
                   install: true,
                   install_dir: [true, true, true, true])


libvqdr_dep = declare_dependency(link_with : libvqdr,
                               dependencies: libvqdr_dependencies,
                               include_directories: include_directories('.'))


vqdr_source_files = source_files + files (['src/main.vala'])
vqdr = executable ('vqdr',
                   vqdr_source_files,
                   dependencies: libvqdr_dependencies,
                   link_with: libvqdr)


subdir ('tests')

subdir ('docs')
