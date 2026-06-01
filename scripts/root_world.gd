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
	
	player.em_cutscene = true
	if filho:
		filho.em_cutscene = true
		filho.global_position = marker_inicial.global_position
		filho.son.modulate.a = 1.0 
		filho.show()
		
		cam.target = filho
	
	Dialogic.start("inicioBuscaFilho")

func iniciar_missao_resgate():
	missao_passarinho_ativa = true
	if is_instance_valid(passarinho):
		passarinho.iniciar_procura()
	print("Missão iniciada! Ouça atentamente os piados.")

func _on_passarinho_salvo():
	missao_passarinho_ativa = false
	print("O passarinho foi salvo!")
	
	await get_tree().create_timer(5.0).timeout
	Dialogic.start("passaroSalvo")
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		iniciar_missao_resgate()
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_L:
		print("Debug: Pulando diálogo e abrindo livro!")
		
		Dialogic.end_timeline() 
		
		if has_node("book/LivroIcon"):
			var icone = $book/LivroIcon
			icone.hide() 
			icone.abrir_livro()

func _on_dialogo_terminado():
	if player.em_cutscene:
		player.em_cutscene = false
		cam.target = player

func _on_dialogic_signal(argument: String):
	match argument:
		"filho_anda_meio":
			filho.anim_cutscene = "walk"
			var tw = create_tween()
			tw.tween_property(filho, "global_position", marker_son_meio.global_position, 2.0)
			await tw.finished
			filho.anim_cutscene = ""
			
		"filho_some_fade":
			filho.anim_cutscene = "walk"
			var tw = create_tween()
			tw.tween_property(filho, "global_position", marker_final.global_position, 3.0)
			await get_tree().create_timer(2.0).timeout 
			TransitionLendas.animator.play("fade_lendas")
			await get_tree().create_timer(3.0).timeout 
			cam.target = player
			filho.queue_free()
		"revelar_horacio":
			player.global_position = marker_player_initial.global_position
			
			var sprite_player = player.get_node("animator3D_sprite")
			sprite_player.play("walk_down")
			sprite_player.stop()
			
			cam.target = player
			
			TransitionLendas.animator.play_backwards("fade_lendas")
			
		"horacio_ve_rastros":
			var sprite_player = player.get_node("animator3D_sprite")
			
			sprite_player.play("walk_right") 
			
			var tw = create_tween()
			tw.tween_property(player, "global_position", marker_player_footprints.global_position, 2.0)
			await tw.finished
			
			sprite_player.stop()
			
			await get_tree().create_timer(10.0).timeout 
			musica_fundo.volume_db = -80.0
			musica_fundo.play()
			
			var twMusic = create_tween()
			twMusic.tween_property(musica_fundo, "volume_db", 0.0, 3.0)
		
		"iniciar_missao":
			iniciar_missao_resgate()
		
		"mostrar_livro":
			if has_node("book/LivroIcon"):
				$book/LivroIcon.aparecer_com_fade()
		
		"book_manage":
			if has_node("book/LivroIcon"):
				$book/LivroIcon.abrir_livro()
		
		"parte2_curupira":
			if has_node("curupiraArea"):
				$curupiraArea.preparar_agradecimento
