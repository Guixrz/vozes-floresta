extends TextureButton

var pode_brilhar: bool = true
var tween_brilho: Tween

func _ready() -> void:
	# Começa completamente invisível e escondido
	modulate.a = 0.0
	hide()
	
	# Conecta o sinal nativo de clique
	pressed.connect(_on_pressed)

# Função que a root_world vai chamar de fora
func aparecer_com_fade() -> void:
	show()
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 1.0) # 1 segundo de Fade In
	await tw.finished
	_iniciar_ciclo_brilho()

func _iniciar_ciclo_brilho() -> void:
	if not pode_brilhar: return
	
	# Cria um Tween infinito para pulsar a cor do ícone
	tween_brilho = create_tween().set_loops()
	
	# Altera a cor própria para um tom mais claro/brilhante em 0.5s
	tween_brilho.tween_property(self, "self_modulate", Color(1.8, 1.8, 1.8, 1.0), 0.5)
	
	# Volta para a cor normal e aguarda 2.5s (completando o ciclo de 3 segundos)
	tween_brilho.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5).set_delay(2.0)

func _on_pressed() -> void:
	# 1. Para o brilho imediatamente
	if tween_brilho and tween_brilho.is_valid():
		tween_brilho.kill()
	
	pode_brilhar = false
	self_modulate = Color(1.0, 1.0, 1.0, 1.0) # Reseta para a cor padrão
	
	# 2. Inicia o diálogo do Dialogic
	# Substitua pelo nome exato da sua timeline do livro
	#Dialogic.start("timeline_livro_passarinho")
