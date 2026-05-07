extends Node3D

@onready var area_gatilho = $area
@onready var player_spot = $MarkerPlayerSpot
@onready var curupira_start = $MarkerCurupiraStart
@onready var curupira_left = $MarkerCurupiraLeft
@onready var curupira = $curupira

var cutscene_iniciada = false

func _ready() -> void:
	curupira.visible = false
	curupira.global_position = curupira_start.global_position
	
	# conecta o gatilho
	area_gatilho.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D) -> void:
	if cutscene_iniciada:
		return
		
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		cutscene_iniciada = true
		rodar_cutscene(body)

func rodar_cutscene(player: Node3D) -> void:
	player.em_cutscene = true
	player.velocity = Vector3.ZERO
	
	definir_animacao_caminhada(player, player_spot.global_position)

	# calcula o tempo de caminhada baseado na distância para manter a velocidade constante!
	var distancia = player.global_position.distance_to(player_spot.global_position)
	var velocidade_caminhada = 2.5
	var tempo_caminhada = distancia / velocidade_caminhada
	
	# move o Player suavemente até a frente da árvore
	var tween_player = create_tween()
	tween_player.tween_property(player, "global_position", player_spot.global_position, tempo_caminhada)
	
	await tween_player.finished
	
	var animator = player.get_node("animator3D_sprite")
	if animator:
		animator.play("walk_down") 
		animator.stop()            
	
	await get_tree().create_timer(2.0).timeout
	
	curupira.visible = true
	
	var tween_curupira = create_tween()
	# efeito de desaceleração
	tween_curupira.tween_property(curupira, "global_position", curupira_left.global_position, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween_curupira.finished
	


# calcula a direção do movimento e escolhe a animação
func definir_animacao_caminhada(player: Node3D, target_pos: Vector3) -> void:
	var animator = player.get_node("animator3D_sprite")
	if not animator:
		return
		
	# calcula o vetor de direção no plano horizontal XZ (ignora a altura Y)
	var direcao = (target_pos - player.global_position)
	direcao.y = 0
	direcao = direcao.normalized()
	
	# Se a movimentação horizontal for maior que a vertical
	if abs(direcao.x) > abs(direcao.z):
		if direcao.x > 0:
			animator.play("walk_right")
		else:
			animator.play("walk_left")
	# Se a movimentação vertical for maior
	else:
		if direcao.z > 0:
			animator.play("walk_front") # Anda em direção à câmera
		else:
			animator.play("walk_down")  # Anda para o fundo (direção à árvore)
