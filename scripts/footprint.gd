extends Area3D

@onready var luz = $OmniLight3D
@export var raio_ativacao: float = 15.0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	body_entered.connect(_on_body_entered)
	
	var otimizador = Timer.new()
	add_child(otimizador)
	otimizador.wait_time = 0.5
	otimizador.autostart = true
	otimizador.timeout.connect(_gerenciar_performance)

func _gerenciar_performance():
	if not player: return
	
	var dist = global_position.distance_to(player.global_position)
	
	if dist > raio_ativacao:
		monitoring = false
		monitorable = false
		set_process(false) 
	else:
		monitoring = true
		monitorable = true
		set_process(true)

func _on_body_entered(body):
	if body.is_in_group("player") or body.name == "player":
		var tween = create_tween()
		tween.parallel().tween_property(luz, "light_energy", 1.25, 1.0)
		tween.tween_property(luz, "light_energy", 0.0, 2.0).set_delay(5.0)
