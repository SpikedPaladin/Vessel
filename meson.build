project(
    'valagl',
    
    ['c', 'vala'],
    version: '1.0',
    meson_version: '>= 0.50.0',
)

pkg = import('pkgconfig')
gnome = import('gnome')

# Load custom vapi files
add_project_arguments(
    ['--vapidir', meson.current_source_dir() / 'vapi'],
    language: 'vala'
)

subdir('data')
subdir('src')

subdir('example')