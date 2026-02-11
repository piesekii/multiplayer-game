shader_type spatial;
render_mode 
    blend_mix,
    depth_draw_opaque,
    cull_back,
    diffuse_toon,
    specular_toon;

/* =======================
   TEXTURAS BASE
   ======================= */

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

uniform sampler2D texture_normal : hint_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16.0, 16.0) = 1.0;

uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
uniform float metallic = 0.0;

uniform sampler2D texture_roughness : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float roughness = 0.4;

/* =======================
   UV CONTROLS
   ======================= */

uniform vec2 uv1_scale = vec2(1.0);
uniform vec2 uv1_offset = vec2(0.0);

/* =======================
   CEL SHADING
   ======================= */

uniform sampler2D color_gradient;   // GradientTexture1D
uniform sampler2D fresnel_gradient; // GradientTexture1D

/* =======================
   FRESNEL
   ======================= */

float fresnel(float power, vec3 normal, vec3 view_dir) {
    float f = 1.0 - clamp(dot(normalize(normal), normalize(view_dir)), 0.0, 1.0);
    return pow(f, power);
}

/* =======================
   VERTEX
   ======================= */

void vertex() {
    UV = UV * uv1_scale + uv1_offset;
}

/* =======================
   FRAGMENT
   ======================= */

void fragment() {
    vec2 base_uv = UV;

    // Albedo
    vec4 albedo_tex = texture(texture_albedo, base_uv);
    ALBEDO = albedo.rgb * albedo_tex.rgb;

    // Fresnel
    float f = fresnel(4.0, NORMAL, VIEW);
    vec3 fresnel_color = texture(fresnel_gradient, vec2(f, 0.0)).rgb;
    ALBEDO *= fresnel_color;

    // Metallic
    float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
    METALLIC = metallic_tex * metallic;

    // Roughness
    float roughness_tex = texture(texture_roughness, base_uv).r;
    ROUGHNESS = roughness_tex * roughness;

    // Normal Map
    NORMAL_MAP = texture(texture_normal, base_uv).rgb;
    NORMAL_MAP_DEPTH = normal_scale;

    SPECULAR = 0.0;
}

/* =======================
   LIGHT (CEL SHADING)
   ======================= */

void light() {
    float ndotl = dot(NORMAL, LIGHT);
    ndotl = clamp(ndotl * 0.5 + 0.5, 0.0, 1.0);

    vec3 shade = texture(color_gradient, vec2(ndotl, 0.0)).rgb;

    DIFFUSE_LIGHT = shade * LIGHT_COLOR * ATTENUATION;
}
