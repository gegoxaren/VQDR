project('vqdr', ['c', 'vala'], 
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)
cc = meson.get_compiler('c')

conf = configuration_data()


dependencies = []

glib_dep = dependency ('glib-2.0', required : true)
gobject_dep = dependency ('gobject-2.0', required : true)
gee_dep = dependency ('gee-0.8', required : true)
gio_dep = dependency ('gio-2.0', required : true)
gmodule_dep = dependency ('gmodule-2.0', requred : true)
m_dep = cc.find_library('m', required : true)
dependencies += [glib_dep, gobject_dep, gee_dep, gio_dep, gmodule_dep, m_dep]

subdir('src')

libvqdr = library ('vqdr',
                        libvqdr_source_files,
                        vala_header: 'libvqdr.h',
                        vala_vapi: 'libvqdr-0.1.vapi',
                        dependencies: dependencies,
                        install: true,
                        install_dir: [true, true, true])


libvqdr_dep = declare_dependency(link_with : libvqdr,
                               dependencies: dependencies,
                               include_directories: include_directories('.'))

vqdr_dependencies = dependencies
vqdr_source_files = source_files + files (['src/main.vala'])
vqdr = executable ('vqdr',
                   vqdr_source_files,
                   dependencies: vqdr_dependencies,
                   link_with: libvqdr)


subdir ('tests')

subdir ('docs')
