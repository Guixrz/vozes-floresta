extends Control


@export var nameWorld:String 

#nodes da ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $config_game_ui.visible:
		$buttons.hide()
		$tittle2.hide()
	else:
		$buttons.show()
		$tittle2.show()


func _on_btn_play_button_down() -> void:
	#quando botao play for apertado carrega uma cena
	#root_world é provisorio, uma outra cena pode ser usada no lugar
	get_tree().change_scene_to_file("res://scenes/"+nameWorld)
	


func _on_btn_extra_button_down() -> void:
	#quando botao extra(agradecimento, tutoriais, ester eggs) for apertado
	pass # Replace with function body.


func _on_btn_config_button_down() -> void:
	$config_game_ui.show()
