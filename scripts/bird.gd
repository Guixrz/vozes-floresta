extends CharacterBody3D

@onready var som = $sound
@onready var area_resgate = $rescueArea
@onready var luz = $lightInteration

signal piou
signal silenciou
signal passarinho_salvo

func _ready():
	if luz:
		luz.light_energy = 0
		
	area_resgate.body_entered.connect(_on_rescue_area_body_entered)
	# Conectamos o fim do som para resetar o estado
	som.finished.connect(_on_som_finished)
	
	if has_node("Timer"):
		$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if som and not som.playing:
		som.play()
		piou.emit()
		
		# === LOOP DE BRILHO DURANTE O CANTO ===
		# Enquanto o pássaro estiver cantando, a luz vai pulsar
		while som.playing:
			if luz:
				var tween = create_tween()
				# Pulso rápido: sobe em 0.2s, desce em 0.5s
				tween.tween_property(luz, "light_energy", 2.5, 0.2)
				tween.tween_property(luz, "light_energy", 0.0, 0.5).set_delay(0.1)
				
				# Espera o pulso terminar antes de verificar se o som ainda toca
				await tween.finished
			
			# Pequena pausa entre um pulso e outro (0.3 segundos de escuridão)
			await get_tree().create_timer(1).timeout
		
		# Quando o som finalmente acabar, avisamos o sistema
		silenciou.emit()

func _on_som_finished():
	# Quando o áudio de 8s acaba, sorteamos um silêncio curto (2 a 4s)
	if has_node("Timer"):
		$Timer.wait_time = randf_range(3.0, 5.0)
		$Timer.start()

func _on_rescue_area_body_entered(body: Node3D):
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		salvar_passarinho()

func salvar_passarinho():
	som.stop()
	silenciou.emit()
	if luz: luz.light_energy = 0
	area_resgate.queue_free()
	passarinho_salvo.emit()
	queue_free()

func iniciar_procura():
	show() 
	_on_timer_timeout() # Começa o ciclo imediatamente
