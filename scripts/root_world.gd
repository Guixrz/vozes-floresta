extends Node3D

@onready var player = $player
@onready var passarinho = $bird
@onready var filho = $sonHoracio
@onready var cam = $cam
@onready var marker_inicial = $MarkerSonInitial
@onready var marker_final = $MarkerSonFinally

var missao_passarinho_ativa = false

func _ready() -> void:
	if passarinho:
		passarinho.passarinho_salvo.connect(_on_passarinho_salvo)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	#if filho:
		#filho.visible = false
	
	Dialogic.start("inicioBuscaFilho")

func iniciar_missao_resgate():
	#coloca na label do UI player - jerry
	missao_passarinho_ativa = true
	if is_instance_valid(passarinho):
		passarinho.iniciar_procura()
	print("Missão iniciada! Ouça atentamente os piados.")

func _on_passarinho_salvo():
	missao_passarinho_ativa = false
	print("O passarinho foi salvo!")

#func _unhandled_input(event: InputEvent) -> void:
	# Tecla de debug
	#if event is InputEventKey and event.pressed and event.keycode == KEY_P:
	#	iniciar_missao_resgate()

func executar_sequencia_filho():
	player.em_cutscene = true
	filho.em_cutscene = true
	
	filho.global_position = marker_inicial.global_position
	filho.son.modulate.a = 1.0 
	filho.show()
	filho.anim_cutscene = "walk"
	
	cam.target = filho
	
	filho.anim_cutscene = "walk"
	
	var tw = create_tween()
	tw.tween_property(filho, "global_position", marker_final.global_position, 4.0)
	
	await tw.finished
	filho.anim_cutscene = ""
	
	cam.target = player
	
	var tw_sumir = create_tween()
	tw_sumir.tween_property(filho.son, "modulate:a", 0.0, 1.0)
	await tw_sumir.finished
	
	filho.queue_free()
	player.em_cutscene = false

func _on_dialogic_signal(argument: String):
	if argument == "buscarFilho":
		executar_sequencia_filho()
