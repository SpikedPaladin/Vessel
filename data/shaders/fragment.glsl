#version 330

precision mediump float;

in vec3 FragPosition;
in vec2 FragTexCoord;
in vec3 FragNormal;
in vec4 FragColor;

out vec4 FinalColor;

// disable shading
uniform bool EnableShading;

// the color of the ambient light
uniform vec3 AmbientLight;

// position of the global light (TODO: have multiple lights)
uniform vec3 LightPosition;
// position of the scene camera
uniform vec3 CameraPosition;

// the strengths of the various lighting types
uniform vec3 AmbientColor;
uniform vec3 DiffuseColor;
uniform vec3 SpecularColor;

uniform float SpecularCoeff;

uniform bool HaveVertexColors;

// the textures
uniform bool HaveAmbientTex;
uniform sampler2D AmbientTex;

uniform bool HaveDiffuseTex;
uniform sampler2D DiffuseTex;

uniform bool HaveSpecularTex;
uniform sampler2D SpecularTex;

// other properties
uniform bool Selected;

void main() {
    if (!EnableShading) {
        FinalColor = FragColor;
        return;
    }
    
    vec3 light = normalize(LightPosition - FragPosition);
    vec3 view = normalize(CameraPosition - FragPosition);
    vec3 normal = normalize(FragNormal);
    
    // ambient lighting
    vec3 ambient = AmbientLight * AmbientColor;
    
    // diffuse lighting
    vec3 diffuse = max(dot(normal, light), 0.0) * DiffuseColor;
    
    // specular lighting
    vec3 specular = pow(max(dot(view, reflect(-light, normal)), 0.0), SpecularCoeff) * SpecularColor;
    
    // textures
    if (HaveAmbientTex)
        ambient *= vec3(texture(AmbientTex, FragTexCoord));
    if (HaveDiffuseTex)
        diffuse *= vec3(texture(DiffuseTex, FragTexCoord));
    if (HaveSpecularTex)
        specular *= vec3(texture(SpecularTex, FragTexCoord));
    
    vec3 color = ambient + diffuse + specular;
    if (Selected)       // highlight the edges of the object if it's selected
        color = mix(color, vec3(1.0, 0.0, 0.0), 1.0 - abs(dot(normal, view)));
    
    if (HaveVertexColors)
        color *= FragColor.rgb;
    
    FinalColor = vec4(color, 1.0);
}
