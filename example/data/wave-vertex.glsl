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
out vec4 f_color;

const vec3 cXAxis = vec3(1.0, 0.0, 0.0);
const vec3 cZAxis = vec3(0.0, 0.0, 1.0);
const float cStrength = 0.5;
const vec3 cYAxis = vec3(0.0, 1.0, 0.0);
vec3 gPosition;

void main(void) {
    gPosition = vertexPosition;
    float xAngle = dot(cXAxis, normalize(gPosition)) * 5.0;
    float yAngle = dot(cYAxis, normalize(gPosition)) * 6.0;
    float zAngle = dot(cZAxis, normalize(gPosition)) * 4.5;
    vec3 timeVec = gPosition;
    float time = time * 0.05;
    float cosX = cos(time + xAngle);
    float sinX = sin(time + xAngle);
    float cosY = cos(time + yAngle);
    float sinY = sin(time + yAngle);
    float cosZ = cos(time + zAngle);
    float sinz = sin(time + zAngle);
    timeVec.x += normalize(gPosition).x * cosX * sinY * cosZ * cStrength;
    timeVec.y += normalize(gPosition).y * sinX * cosY * sinz * cStrength;
    timeVec.z += normalize(gPosition).z * sinX * cosY * cosZ * cStrength;
    gPosition = timeVec;
    
    gl_Position = modelViewProjection * vec4(gPosition, 1.0);
    f_color = vec4(normalize(gPosition), 1.0);
}
