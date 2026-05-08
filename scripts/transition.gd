extends CanvasLayer

@onready var background = $background
@onready var animator = $AnimationPlayer
@onready var img_resgate = $imageRescue # Nome exato que vi na sua árvore de cena

var scene: String

# Sua função de troca de cena (original)
func fade_to_scene(new_scene: String) -> void:
	scene = new_scene
	animator.play("fade_lendas")

func chance_scene() -> void:
	get_tree().change_scene_to_file(scene)

# === FUNÇÃO DE RESGATE (CORRIGIDA) ===
func tocar_cutscene_resgate():
	var tween = create_tween()
	
	# 1. Escurece a tela (Fade Out)
	tween.tween_property(background, "color:a", 1.0, 1.0)
	
	# 2. Mostra o PNG do resgate
	tween.tween_property(img_resgate, "modulate:a", 1.0, 0.5)
	
	# 3. Pausa de 3 segundos
	tween.tween_interval(3.0)
	
	# 4. Esconde o PNG e clareia a tela (Fade In)
	tween.tween_property(img_resgate, "modulate:a", 0.0, 0.5)
	tween.tween_property(background, "color:a", 0.0, 1.0)
	
	# 5. Chama a função de limpeza no final
	tween.tween_callback(_liberar_player)

# Função auxiliar para evitar erros de sintaxe no Tween
func _liberar_player():
	var player = get_tree().current_scene.get_node_or_null("player")
	if player:
		player.em_cutscene = false
