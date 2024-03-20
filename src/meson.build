vessel_deps = [
    dependency('gtk4'),
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('gl')
]

vessel_sources = files()

subdir('cameras')
subdir('materials')
subdir('math')
subdir('resources')
subdir('scene')
subdir('utils')

lib = library(
    'vessel',
    
    vessel_resources,
    vessel_sources,
    dependencies: vessel_deps,
    link_args : ['-lepoxy', '-lm' ],
    install: true,
    install_dir: [true, true, true]
)

pkg.generate(
    name: 'Vessel',
    description: '3D engine build with Vala',
    
    libraries: lib,
    version: meson.project_version(),
    subdirs: 'vessel',
    filebase: 'vessel',
    requires: []
)

lib_dependency = declare_dependency(
    link_with: lib,
    include_directories: include_directories('.')
)