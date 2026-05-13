shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform int clones = 8;

uniform vec2 direction = vec2(-1.0, 0.0);
uniform float spread = 0.06;

uniform float fade_power = 1.5;
uniform float distort = 0.02;

// cor dos clones
uniform vec3 clone_color = vec3(0.6, 0.0, 1.0);

// aura
uniform vec3 aura_color = vec3(0.3, 0.8, 1.0);
uniform float aura_strength = 1.5;
uniform float aura_size = 0.01;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    vec4 final_color = vec4(0.0);

    // --- CLONES ---
    for (int i = 0; i < clones; i++) {
        float t = float(i) / float(clones);

        vec2 offset = direction * spread * t * progress;

        float wave = sin((UV.y + t * 10.0 + TIME * 5.0)) * distort * t;
        offset.x += wave;

        vec2 sample_uv = UV - offset;

        vec4 col = texture(TEXTURE, sample_uv);

        float alpha = pow(1.0 - t, fade_power);
        alpha *= smoothstep(1.0, 0.0, progress - t);

        col.a *= alpha;

        // cor energética
        col.rgb = mix(col.rgb, clone_color, t);

        final_color += col;
    }

    // --- ORIGINAL ---
    final_color += base * (1.0 - progress);

    // --- AURA ---
    float alpha_base = base.a;

    // borda simples expandida
    float aura = 0.0;

    aura += texture(TEXTURE, UV + vec2(aura_size, 0.0)).a;
    aura += texture(TEXTURE, UV + vec2(-aura_size, 0.0)).a;
    aura += texture(TEXTURE, UV + vec2(0.0, aura_size)).a;
    aura += texture(TEXTURE, UV + vec2(0.0, -aura_size)).a;

    aura = aura * 0.25 - alpha_base; // pega só a borda externa
    aura = max(aura, 0.0);

    vec3 aura_final = aura_color * aura * aura_strength;

    final_color.rgb += aura_final;

    COLOR = final_color;
}