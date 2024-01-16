vessel_deps = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('gl')
]

vessel_sources = files(
    'buffer-info.vala',
    'geometry-3d.vala',
    'object-3d.vala',
    'transformable-3d.vala',
)

subdir('cameras')
subdir('lights')
subdir('materials')
subdir('math')
subdir('primitives')
subdir('renderer')
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