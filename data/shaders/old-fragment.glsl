#version 330

in vec3 Normal;
in vec4 f_color;
in vec3 FragPos;
out vec4 FragColor;

uniform vec3 lightPos;
vec3 lightDir = vec3(0, 0, -1);
vec3 lightColor = vec3(1, 1, 1);
vec3 ambientColor = vec3(1, 1, 1);
float ambientStrength = 1.0;

void main(void) {
    vec3 ambient = ambientStrength * ambientColor;
    
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(lightPos - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightColor;
    vec4 result = vec4(ambient + diffuse, 1.0) * f_color;
    
    FragColor = result;
}
