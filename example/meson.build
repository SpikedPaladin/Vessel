subdir('data')

example_deps = [
    lib_dependency,
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gio-2.0'),
    dependency('gtk4'),
    dependency('libadwaita-1'),
    dependency('gl')
]

example_sources = files(
    'app.vala',
    
    'rubik/animation-queue.vala',
    'rubik/colored-cube.vala',
    'rubik/rubik-cube.vala',
    'ui/main-window.vala',
)

executable(
    'example',
    
    example_resources,
    example_sources,
    vala_args: [ '--target-glib=2.58', '--gresourcesdir=example/data/' ],
    dependencies: example_deps,
    link_args : ['-lepoxy', '-lm' ],
    install: false,
)
