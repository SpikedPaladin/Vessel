blueprints = custom_target(
    'blueprints',
    
    input: files(
        'window.blp',
    ),
    output: '.',
    command: [ find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@' ],
)

# Include shaders in executable
example_resources = gnome.compile_resources(
    'example-resources',
    'example.gresource.xml',
    dependencies: blueprints
)