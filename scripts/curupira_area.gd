extends Node3D

@onready var area_gatilho = $area
@onready var player_spot = $MarkerPlayerSpot
@onready var curupira_start = $MarkerCurupiraStart
@onready var curupira_left = $MarkerCurupiraLeft
@onready var curupira = $curupira

var cutscene_iniciada = false
var fase_missao = 1

func _ready() -> void:
	curupira.visible = false
	curupira.global_position = curupira_start.global_position
	
	area_gatilho.body_entered.connect(_on_player_entered)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	if argument == "mostrar_ninho":
		curupira.mudarEstado(true)

func preparar_agradecimento():
	cutscene_iniciada = false
	fase_missao = 2
	curupira.visible = true 
	area_gatilho.set_deferred("monitoring", true)   

func _on_player_entered(body: Node3D) -> void:
	if cutscene_iniciada:
		return
		
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		cutscene_iniciada = true
		
		if fase_missao == 1:
			rodar_cutscene(body)
		elif fase_missao == 2:
			rodar_cutscene_agradecimento(body)

func rodar_cutscene(player: Node3D) -> void:
	player.em_cutscene = true
	player.velocity = Vector3.ZERO
	
	var distancia = player.global_position.distance_to(player_spot.global_position)
	if distancia > 0.5:
		GameUtils.definir_animacao_caminhada(player, player_spot.global_position)
		var tempo_caminhada = distancia / 2.5
		
		var tween_player = create_tween()
		tween_player.tween_property(player, "global_position", player_spot.global_position, tempo_caminhada)
		await tween_player.finished
	
	var animator = player.get_node("animator3D_sprite")
	if animator:
		animator.play("walk_front") 
		animator.stop()            
	
	await get_tree().create_timer(2.0).timeout
	curupira.visible = true
	
	var tween_curupira = create_tween()
	tween_curupira.tween_property(curupira, "global_position", curupira_left.global_position, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween_curupira.finished
	
	Dialogic.start("curupira")

func rodar_cutscene_agradecimento(player: Node3D) -> void:
	player.em_cutscene = true
	player.velocity = Vector3.ZERO
	
	var distancia = player.global_position.distance_to(player_spot.global_position)
	if distancia > 0.5:
		GameUtils.definir_animacao_caminhada(player, player_spot.global_position)
		var tempo_caminhada = distancia / 2.5
		
		var tween_player = create_tween()
		tween_player.tween_property(player, "global_position", player_spot.global_position, tempo_caminhada)
		await tween_player.finished
	
	var animator = player.get_node("animator3D_sprite")
	if animator:
		animator.play("walk_front") 
		animator.stop()            
	
	await get_tree().create_timer(1.0).timeout
	
	Dialogic.start("curupira_finalizacao")
