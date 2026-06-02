extends Area3D

@export var curupira_node: Node3D # Arraste o nó do Curupira para cá no Inspetor!
@onready var player_spot: Marker3D = $"../MarkerFinalPlayer"


func _ready():
	monitoring = false
	
	body_entered.connect(_on_body_entered)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument: String):
	if argument == "parte2_curupira":
		set_deferred("monitoring", true)
		
		if curupira_node:
			curupira_node.visible = true

func _on_body_entered(body: Node3D):
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		set_deferred("monitoring", false)
		
		rodar_cutscene_final(body)

func rodar_cutscene_final(player: Node3D) -> void:
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
	
	Dialogic.start("curupira_finalizacao")
