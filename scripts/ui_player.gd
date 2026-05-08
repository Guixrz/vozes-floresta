extends Control

signal bookEnters
var isActiveBook:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#$bestiary_btn.hide()#só será chamado quando falar com o curupira, portanto ficará escondido


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showBestiaryBtn() -> void:
	$bestiary_btn.show()
func _on_bestiary_btn_button_down() -> void:
	isActiveBook = !isActiveBook
	bookEnters.emit(isActiveBook)
	if isActiveBook: 
		#pra nao repetir toda hora esse dialogo, bota uma variavel de controle
		Dialogic.start("timelines")
	
