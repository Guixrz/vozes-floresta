extends CharacterBody3D

@onready var som = $sound
@onready var area_resgate = $rescueArea
@onready var luz = $lightInteration
@onready var playerSplot: Marker3D = $playerSplot
@onready var timer = $Timer

signal piou
signal silenciou
signal passarinho_salvo

func _ready():
	hide() 
	if luz: luz.light_energy = 0
	
	
	area_resgate.monitoring = false 
	
	area_resgate.body_entered.connect(_on_rescue_area_body_entered)
	som.finished.connect(_on_som_finished)
	if timer:
		timer.timeout.connect(_on_timer_timeout)

func iniciar_procura():
	show()
	area_resgate.set_deferred("monitoring", true) 
	_on_timer_timeout()


func _on_timer_timeout():
	if not som.playing:
		som.play()
		piou.emit()
		
		if luz:
			var tween = create_tween()
			tween.tween_property(luz, "light_energy", 2.5, 0.3)
			tween.tween_property(luz, "light_energy", 0.0, 1.0).set_delay(1.0)
func _on_som_finished():
	silenciou.emit()
	if timer:
		timer.wait_time = randf_range(3.0, 5.0)
		timer.start()

func _on_rescue_area_body_entered(body: Node3D):
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		salvar_passarinho(body)

func salvar_passarinho(player_instancia: Node3D):
	som.stop()
	if timer: timer.stop() # 
	silenciou.emit()
	
	if luz: luz.light_energy = 0
	area_resgate.set_deferred("monitoring", false)
	
	player_instancia.em_cutscene = true
	player_instancia.velocity = Vector3.ZERO
	
	GameUtils.definir_animacao_caminhada(player_instancia, playerSplot.global_position)
	
	var tw = create_tween()
	var tempo = player_instancia.global_position.distance_to(playerSplot.global_position) / 2.5
	tw.tween_property(player_instancia, "global_position", playerSplot.global_position, tempo)
	
	await tw.finished
	
	player_instancia.get_node("animator3D_sprite").stop()

	if TransitionLendas:
		TransitionLendas.tocar_cutscene_resgate()
	else:
		print("singleton TransitionLendas não encontrado!")

	await get_tree().create_timer(1.0).timeout
	
	passarinho_salvo.emit()
	queue_free()
