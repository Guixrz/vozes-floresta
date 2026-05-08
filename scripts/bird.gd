extends CharacterBody3D

@onready var som = $sound
@onready var area_resgate = $rescueArea
@onready var luz = $lightInteration
@onready var playerSplot: Marker3D = $playerSplot # Mantenha o nome exato do nó na árvore

signal piou
signal silenciou
signal passarinho_salvo

func _ready():
	if luz: luz.light_energy = 0
	area_resgate.body_entered.connect(_on_rescue_area_body_entered)
	som.finished.connect(_on_som_finished)
	if has_node("Timer"):
		$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if som and not som.playing:
		som.play()
		piou.emit()
		while som.playing:
			if luz:
				var tween = create_tween()
				tween.tween_property(luz, "light_energy", 2.5, 0.2)
				tween.tween_property(luz, "light_energy", 0.0, 0.5).set_delay(0.1)
				await tween.finished
			await get_tree().create_timer(1).timeout
		silenciou.emit()

func _on_som_finished():
	if has_node("Timer"):
		$Timer.wait_time = randf_range(3.0, 5.0)
		$Timer.start()

func _on_rescue_area_body_entered(body: Node3D):
	# CORREÇÃO: Passamos 'body' (a instância), não 'Player' (a classe)
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		salvar_passarinho(body)

func salvar_passarinho(player_instancia: Node3D):
	som.stop()
	silenciou.emit()
	if luz: luz.light_energy = 0
	area_resgate.set_deferred("monitoring", false)
	
	player_instancia.em_cutscene = true
	player_instancia.velocity = Vector3.ZERO
	
	# Chamando a função global que criamos no Passo 1
	GameUtils.definir_animacao_caminhada(player_instancia, playerSplot.global_position)
	
	var tw = create_tween()
	var tempo = player_instancia.global_position.distance_to(playerSplot.global_position) / 2.5
	tw.tween_property(player_instancia, "global_position", playerSplot.global_position, tempo)
	
	await tw.finished
	
	var trans = get_tree().current_scene.get_node_or_null("CanvasLayer/transition")
	if trans:
		trans.tocar_cutscene_resgate()
	
	# Remove o passarinho enquanto a tela está preta
	await get_tree().create_timer(1.0).timeout
	
	passarinho_salvo.emit()
	 
	queue_free()

func iniciar_procura():
	show()
	_on_timer_timeout()
