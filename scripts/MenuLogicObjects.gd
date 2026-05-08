extends Control

@onready var audioObj:AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_config_game_ui_button_sounds() -> void:
	if audioObj.playing:
		audioObj.stop()
	else:
		audioObj.play()
