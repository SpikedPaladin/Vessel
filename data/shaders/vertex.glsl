#version 330

in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

out vec2 TexCoord;
out vec3 Normal;
out vec3 FragPosition;
out vec4 VertexColor;

uniform mat4 modelViewProjection;
uniform mat4 model;

void main() {
    gl_Position = modelViewProjection * vec4(vertexPosition, 1.0);
    TexCoord = vertexTexCoord;
    // XXX: calculate transpose-inverse of model on the CPU side
    Normal = normalize(mat3(transpose(inverse(model))) * vertexNormal);
    FragPosition = vec3(model * vec4(vertexPosition, 1.0));
    VertexColor = vertexColor;
}
