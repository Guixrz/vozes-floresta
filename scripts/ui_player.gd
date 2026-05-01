extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$bestiary_btn.hide()#só será chamado quando falar com o curupira, portanto ficará escondido


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showBestiaryBtn() -> void:
	$bestiary_btn.show()
func _on_bestiary_btn_button_down() -> void:
	print("")
