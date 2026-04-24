shader_type spatial;
uniform sampler2D albedo_texture : source_color;
uniform float wind_strength = 0.08;
uniform float wind_speed = 3;
render_mode unshaded, cull_disabled;

void vertex() {
    float height_factor = 1.0 - UV.y;
    
    float wind1 = sin(TIME * wind_speed + float(INSTANCE_ID));
    float wind2 = sin(TIME * (wind_speed + 0.8) + float(INSTANCE_ID));
    float offset  = NODE_POSITION_WORLD.x * 0.7;
 
    VERTEX.x -= (wind1 + wind2) * wind_strength * height_factor + offset;
}
void fragment() {
    vec4 tex = texture(albedo_texture, UV);

    ALBEDO = tex.rgb;
    ALPHA = tex.a;
}