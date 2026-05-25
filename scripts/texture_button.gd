extends TextureButton

@onready var openBook = $openBook # Nome do seu TextureRect interno

var pode_brilhar: bool = true
var tween_brilho: Tween

func _ready() -> void:
	modulate.a = 0.0
	openBook.modulate.a = 0.0
	openBook.hide()
	hide()
	pressed.connect(_on_pressed)
	
	# O ícone agora também escuta o Dialogic!
	Dialogic.signal_event.connect(_on_dialogic_signal)

func aparecer_com_fade() -> void:
	show()
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 1.0)
	await tw.finished
	_iniciar_ciclo_brilho()

func _iniciar_ciclo_brilho() -> void:
	if not pode_brilhar: return
	tween_brilho = create_tween().set_loops()
	tween_brilho.tween_property(self, "self_modulate", Color(1.8, 1.8, 1.8, 1.0), 0.5)
	tween_brilho.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_delay(2.0)

func _on_pressed() -> void:
	disabled = true
	pode_brilhar = false
	if tween_brilho and tween_brilho.is_valid():
		tween_brilho.kill()
		self_modulate = Color(1, 1, 1, 1)

	# 1. Faz apenas o ícone pequeno sumir
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.5)
	await tw.finished
	hide()
	
	# 2. Inicia o Dialogic imediatamente
	# O Horácio vai falar ANTES do livro abrir
	Dialogic.start("book")

func _on_dialogic_signal(argument: String):
	# 3. Quando o Dialogic mandar o sinal, o livro grande aparece suavemente
	if argument == "bookManage":
		openBook.show()
		var tw = create_tween()
		tw.tween_property(openBook, "modulate:a", 1.0, 1.0)
