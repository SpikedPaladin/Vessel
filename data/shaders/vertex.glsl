#version 330

// Input vertex attributes
in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

// Input uniform variables
uniform mat4 modelViewProjection;
uniform mat4 model;

// Output vertex attributes
out vec3 FragPosition;
out vec2 FragTexCoord;
out vec3 FragNormal;
out vec4 FragColor;

void main() {
    // Send vertex attributes to fragment shader
    FragPosition = vec3(model * vec4(vertexPosition, 1.0));
    FragTexCoord = vertexTexCoord;
    FragColor = vertexColor;
    // XXX: calculate transpose-inverse of model on the CPU side
    FragNormal = normalize(mat3(transpose(inverse(model))) * vertexNormal);
    
    // Final vertex position
    gl_Position = modelViewProjection * vec4(vertexPosition, 1.0);
}
