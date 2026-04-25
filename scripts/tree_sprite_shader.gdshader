shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform sampler2D albedo_texture : source_color;
global uniform vec3 player_position; // Recebe a posição do script

void fragment() {
    vec4 tex = texture(albedo_texture, UV);
    ALBEDO = tex.rgb;

    // Calcula a distância entre o pixel da árvore e o player
    float dist = distance(NODE_POSITION_WORLD + VERTEX, player_position);

    // Se estiver perto, diminui o Alpha (o 2.0 é o tamanho do furo)
    float mask = smoothstep(1.0, 2.0, dist); 
    ALPHA = tex.a * mask;
}