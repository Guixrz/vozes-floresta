extends Node3D

@onready var player = $player
@onready var passarinho = $bird
@onready var filho = $sonHoracio
@onready var cam = $cam
@onready var musica_fundo = $music

# Marcadores do Filho
@onready var marker_inicial = $MarkerSonInitial
@onready var marker_son_meio = $MarkerSonMiddle
@onready var marker_final = $MarkerSonFinally

# Marcadores do Horácio (Player)
@onready var marker_player_initial = $MarkerPlayerInitial
@onready var marker_player_footprints = $MarkerPlayerFootprints

var missao_passarinho_ativa = false

func _ready() -> void:
	if passarinho:
		passarinho.passarinho_salvo.connect(_on_passarinho_salvo)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_dialogo_terminado)
	
	# Trava o player imediatamente ao carregar a cena
	player.em_cutscene = true
	if filho:
		filho.em_cutscene = true
		filho.global_position = marker_inicial.global_position
		filho.son.modulate.a = 1.0 
		filho.show()
		
		# A câmera começa focada no filho
		cam.target = filho
	
	# Inicia a Timeline principal (que agora vai gerenciar toda a cena)
	Dialogic.start("inicioBuscaFilho")

func iniciar_missao_resgate():
	missao_passarinho_ativa = true
	if is_instance_valid(passarinho):
		passarinho.iniciar_procura()
	print("Missão iniciada! Ouça atentamente os piados.")

func _on_passarinho_salvo():
	missao_passarinho_ativa = false
	print("O passarinho foi salvo!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		iniciar_missao_resgate()

func _on_dialogo_terminado():
	# Libera o player apenas quando a cutscene ou o livro terminarem completamente
	if player.em_cutscene:
		player.em_cutscene = false
		cam.target = player

# --- MÁQUINA DE ESTADOS DA CUTSCENE ---
func _on_dialogic_signal(argument: String):
	match argument:
		# 1. Filho anda até o meio
		"filho_anda_meio":
			filho.anim_cutscene = "walk"
			var tw = create_tween()
			tw.tween_property(filho, "global_position", marker_son_meio.global_position, 2.0)
			await tw.finished
			filho.anim_cutscene = ""
			
		# 2. Filho corre pra floresta e a tela apaga (Fade)
		"filho_some_fade":
			filho.anim_cutscene = "walk"
			var tw = create_tween()
			tw.tween_property(filho, "global_position", marker_final.global_position, 3.0)
			await get_tree().create_timer(2.0).timeout 
			# Tela escurece
			TransitionLendas.animator.play("fade_lendas")
			# Opcional: Espera 1 segundo para a tela ficar totalmente preta antes de deletar
			await get_tree().create_timer(3.0).timeout 
			cam.target = player
			filho.queue_free() # Agora é seguro remover o filho da cena
		# 3. Revela o Horácio na porta de casa
		"revelar_horacio":
			# Posiciona o Horácio no marcador inicial
			player.global_position = marker_player_initial.global_position
			
			# Acessa o sprite do player e força ele a olhar para a câmera (frente)
			var sprite_player = player.get_node("animator3D_sprite")
			sprite_player.play("walk_down") # Inicia a animação de frente
			sprite_player.stop() # Para no frame 0 (estado 'idle' de frente)
			
			cam.target = player
			
			# A tela clareia
			TransitionLendas.animator.play_backwards("fade_lendas")
			
		# 4. Horácio anda até os rastros
		"horacio_ve_rastros":
			var sprite_player = player.get_node("animator3D_sprite")
			
			# 1. Muda a animação para caminhar para a direita (ou a direção dos rastros)
			sprite_player.play("walk_right") 
			
			# 2. Faz o movimento físico até o marcador
			var tw = create_tween()
			tw.tween_property(player, "global_position", marker_player_footprints.global_position, 2.0)
			await tw.finished
			
			# 3. Quando chegar, para a animação (volta para idle)
			sprite_player.stop()
			
			await get_tree().create_timer(4.0).timeout 
			if not musica_fundo.playing:
				musica_fundo.play()
		# Chamada do Livro (Mantido)
		"mostrar_livro":
			if has_node("book/LivroIcon"):
				$book/LivroIcon.aparecer_com_fade()
