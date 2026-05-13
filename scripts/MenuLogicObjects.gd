extends CanvasLayer

@onready var audioObj:AudioStreamPlayer2D = $bgsound
@onready var audioObj2:AudioStreamPlayer2D = $bgsound2



func _on_config_game_ui_button_sounds() -> void:
	if audioObj.playing:
		audioObj.stop()
		audioObj2.stop()
	else:
		audioObj.play()
		audioObj2.play()
