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

uniform float time;

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
    FragColor = vec4(normalize(gPosition), 1.0);
}
