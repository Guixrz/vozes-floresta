extends TextureButton

@onready var openBook = $openBook
@onready var texto_livro = $openBook/text 
@onready var texto_livro2 = $openBook/text2       # Novo nó de texto
@onready var imagem_curupira = $openBook/curupira # Novo nó da imagem
@onready var som_escrita = $openBook/read

var pode_brilhar: bool = true
var tween_brilho: Tween
var estado_livro: String = "fechado" 

var conteudo_parte_1: String = "Curupira, uma lenda reconhecida do folclore brasileiro, protetor das florestas e dos animais,mais conhecido pelos pés virados para trás e pelos seus cabelos vermelhos. Um ser de tamanha compreensão dos princípios florestais a níveis de exuração aos que destroem, um ser que cria ilusões e observa atentamente por detrás de arbustos e arvores a sua vilania."
var conteudo_parte_2: String = "Parece que ele não raptou meu filho, por ora devo seguir na busca e confiar em suas palavras, tendo em vista que apenas quer a proteção de seu lar, ao menos eu acho..."

func _ready() -> void:
	openBook.set_anchors_preset(Control.PRESET_CENTER)
	
	self_modulate.a = 0.0 
	openBook.modulate.a = 0.0
	openBook.hide()
	
	texto_livro.visible_characters = 0 
	if texto_livro2: texto_livro2.visible_characters = 0
	if imagem_curupira: imagem_curupira.modulate.a = 0.0
	
	pressed.connect(_on_pressed)

func aparecer_com_fade() -> void:
	show()
	disabled = false
	var tw = create_tween()
	tw.tween_property(self, "self_modulate:a", 1.0, 1.0)
	await tw.finished
	pode_brilhar = true
	_iniciar_ciclo_brilho()

func _iniciar_ciclo_brilho() -> void:
	if not pode_brilhar: return
	tween_brilho = create_tween().set_loops()
	tween_brilho.tween_property(self, "self_modulate", Color(1.8, 1.8, 1.8, 1.0), 0.5)
	tween_brilho.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_delay(2.0)

func _on_pressed() -> void:
	disabled = true
	pode_brilhar = false
	estado_livro = "abrindo"
	
	if tween_brilho and tween_brilho.is_valid():
		tween_brilho.kill()

	var tw = create_tween()
	tw.tween_property(self, "self_modulate:a", 0.0, 0.5)
	await tw.finished
	
	self_modulate.a = 0.0
	release_focus() 
	
	Dialogic.start("book")

func abrir_livro():
	self_modulate.a = 0.0 
	openBook.show()
	
	var tw = create_tween()
	tw.tween_property(openBook, "modulate:a", 1.0, 1.0)
	await tw.finished 
	
	estado_livro = "aberto"
	_escrever_textos_animados()

func _escrever_textos_animados() -> void:
	texto_livro.text = conteudo_parte_1
	texto_livro.visible_characters = 0
	var total_letras_1 = conteudo_parte_1.length()
	
	for i in range(total_letras_1):
		if estado_livro != "aberto": return # Interrompe se o jogador fechar o livro
		texto_livro.visible_characters += 1
		_tocar_som_escrita()
		await get_tree().create_timer(0.05).timeout

	if estado_livro != "aberto": return

	var tw = create_tween()
	tw.tween_property(imagem_curupira, "modulate:a", 1.0, 1.0)
	await tw.finished
	
	if estado_livro != "aberto": return

	texto_livro2.text = conteudo_parte_2
	texto_livro2.visible_characters = 0
	var total_letras_2 = conteudo_parte_2.length()
	
	for i in range(total_letras_2):
		if estado_livro != "aberto": return
		texto_livro2.visible_characters += 1
		_tocar_som_escrita()
		await get_tree().create_timer(0.05).timeout

func _tocar_som_escrita() -> void:
	if not som_escrita.playing:
		som_escrita.pitch_scale = randf_range(0.9, 1.1)
		som_escrita.play()

func _input(event: InputEvent) -> void:
	if estado_livro == "aberto":
		var clicou = event is InputEventMouseButton and event.pressed
		var apertou_espaco = event is InputEventKey and event.pressed and event.keycode == KEY_SPACE
		
		if clicou or apertou_espaco:
			fechar_livro()

func fechar_livro() -> void:
	estado_livro = "fechado"
	
	var tw = create_tween()
	tw.tween_property(openBook, "modulate:a", 0.0, 0.5)
	await tw.finished
	openBook.hide()
	
	texto_livro.visible_characters = 0
	if texto_livro2: texto_livro2.visible_characters = 0
	if imagem_curupira: imagem_curupira.modulate.a = 0.0
	
	aparecer_com_fade()
