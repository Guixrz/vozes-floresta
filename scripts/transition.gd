extends CanvasLayer

@onready var background = $background
@onready var animator = $AnimationPlayer
@onready var img_resgate = $imageRescue 
var scene: String

func fade_to_scene(new_scene: String) -> void:
	scene = new_scene
	animator.play("fade_lendas")

func chance_scene() -> void:
	get_tree().change_scene_to_file(scene)

func tocar_cutscene_resgate():
	var tween = create_tween()
	
	tween.tween_property(background, "color:a", 1.0, 1.0)
	
	tween.tween_property(img_resgate, "modulate:a", 1.0, 0.5)
	
	tween.tween_interval(3.0)
	
	tween.tween_property(img_resgate, "modulate:a", 0.0, 0.5)
	tween.tween_property(background, "color:a", 0.0, 1.0)
	
	tween.tween_callback(_liberar_player)

func _liberar_player():
	var player = get_tree().current_scene.get_node_or_null("player")
	if player:
		player.em_cutscene = false
