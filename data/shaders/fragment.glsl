#version 330

precision mediump float;

out vec4 FragColor;

in vec2 TexCoord;
in vec3 Normal;
in vec3 FragPosition;
in vec4 VertexColor;

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
    vec3 ambient = AmbientLight * AmbientColor;

    // direction to light
    vec3 Li = normalize(LightPosition - FragPosition);
    // direction to camera
    vec3 v = normalize(CameraPosition - FragPosition);
    // half vector (bisects Li and V)
    vec3 h = (v + Li) / length(v + Li);

    // diffuse lighting
    vec3 diffuse = max(dot(Normal, Li), 0.0) * DiffuseColor;

    // specular lighting
    vec3 specular = pow(max(dot(Normal, h), 0.0), SpecularCoeff) * SpecularColor;

    // textures
    if (HaveAmbientTex)
        ambient *= vec3(texture(AmbientTex, TexCoord));
    if (HaveDiffuseTex)
        diffuse *= vec3(texture(DiffuseTex, TexCoord));
    if (HaveSpecularTex)
        specular *= vec3(texture(SpecularTex, TexCoord));

    vec3 color = ambient + diffuse + specular;
    if (Selected)       // highlight the edges of the object if it's selected
        color = mix(color, vec3(1.0, 0.0, 0.0), 1.0 - abs(dot(Normal, v)));
    
    if (HaveVertexColors)
        color = VertexColor.rgb;
    
    FragColor = vec4(color, 1.0);
}
