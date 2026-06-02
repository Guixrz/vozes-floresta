extends CanvasLayer

@onready var audioObj:AudioStreamPlayer2D = $bgsound

func _on_config_game_ui_button_sounds() -> void:
	if audioObj.playing:
		audioObj.stop()
	else:
		audioObj.play()
