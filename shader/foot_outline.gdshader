shader_type spatial;
render_mode unshaded, depth_draw_opaque; // Unshaded ativado

uniform sampler2D textura_pegada : source_color, filter_linear_mipmap;

uniform vec4 cor_do_radar : source_color = vec4(0.0, 1.0, 1.0, 1.0); 
uniform float intensidade_radar : hint_range(0.0, 5.0) = 1.5; // Valores menores no unshaded

uniform float raio_revelacao = 4.5;       
uniform float velocidade_onda = 4.0;      
uniform float frequencia_onda = 1.5;      
uniform float espessura_linha = 0.12;     

global uniform vec3 player_position;
varying vec3 pos_mundo;

void vertex() {
	pos_mundo = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec4 tex_color = texture(textura_pegada, UV);
	
	if (tex_color.a < 0.05) {
		discard;
	}

	float distancia = distance(pos_mundo, player_position);
	float mascara_proximidade = 1.0 - smoothstep(raio_revelacao - 1.0, raio_revelacao, distancia);
	
	float onda_seno = sin((distancia * frequencia_onda) - (TIME * velocidade_onda));
	float linha_radar = smoothstep(1.0 - espessura_linha, 1.0, onda_seno);
	float efeito_final_radar = linha_radar * mascara_proximidade;

	// NO UNSHADED: Misturamos a cor marrom com a cor do radar usando mix()
	// Quando o radar passa (efeito_final_radar = 1.0), ele muda a cor do próprio tecido do pé para o azul
	vec3 cor_final = mix(tex_color.rgb, cor_do_radar.rgb, efeito_final_radar * intensidade_radar);

	// Enviamos a cor misturada para o ALBEDO, já que o EMISSION é ignorado/inútil no unshaded puro
	ALBEDO = cor_final;
	ALPHA = tex_color.a; 
}
// desculpa, usei IA :/
