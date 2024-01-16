#version 330

uniform mat4 modelViewProjection;
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
in vec3 vertexPosition;
in vec3 vertexNormal;
in vec2 vertexTexCoord;
in vec4 vertexColor;
uniform vec4 color;
uniform float time;

out vec3 Normal;
out vec4 f_color;
out vec3 FragPos;

void main(void) {
    gl_Position = modelViewProjection * vec4(vertexPosition, 1.0);
    FragPos = vec3(model * vec4(vertexPosition, 1.0));
    Normal = mat3(transpose(inverse(model))) * vertexNormal;
    f_color = color + vertexColor;
}
