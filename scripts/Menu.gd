extends Control


@export var nameWorld:String 
@onready var audioClick:AudioStreamPlayer2D = $"../clickSound"

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


func _on_play_btn_button_down() -> void:
	audioClick.play()
	TransitionLendas.fade_to_scene(nameWorld)
	

func _on_extra_btn_button_down() -> void:
	audioClick.play()

func _on_option_btn_button_down() -> void:
	$config_game_ui.show()
	audioClick.play()


func _on_quit_btn_button_down() -> void:
	get_tree().quit()
