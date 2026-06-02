extends Control


@export var nameWorld:String 
@onready var audioClick:AudioStreamPlayer2D = $"../clickSound"
@onready var animator:AnimationPlayer = $AnimationPlayer

#nodes da ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


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


func _on_play_btn_mouse_entered() -> void:
	animator.play("play_on_mouse")


func _on_option_btn_mouse_entered() -> void:
	animator.play("option_on_mouse")


func _on_quit_btn_mouse_entered() -> void:
	animator.play("sair_on_mouse")
