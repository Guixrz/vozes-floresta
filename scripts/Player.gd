extends CharacterBody3D

@export var anim_cutscene: String = ""
@export var em_cutscene: bool = false
@export var SPEED: float = 2.5
@onready var som_passos: AudioStreamPlayer3D = $passosSound

@onready var animConfig: AnimatedSprite3D = $animator3D_sprite

func _physics_process(_delta: float) -> void:
	#muito bem...
	RenderingServer.global_shader_parameter_set("player_position", global_position)
	if em_cutscene:
		if anim_cutscene == "walk":
			animConfig.play("walk_right")
		return # impede o movimento manual via teclado
	
	handle_movement()

func handle_movement() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		velocity.x = input_dir.x * SPEED
		velocity.z = input_dir.y * SPEED
		move_and_slide()
		update_animation(input_dir)
		
		# Lógica do som de passos
		if not som_passos.playing:
			som_passos.pitch_scale = randf_range(0.9, 1.1) # Variação para não soar robótico
			som_passos.play()
	else:
		velocity = Vector3.ZERO # Garante parada total
		animConfig.stop()
		som_passos.stop() # Para o som instantaneamente ao soltar a tecla

func update_animation(dir: Vector2) -> void:
	#prioriza a direção com maior valor de input
	if abs(dir.x) > abs(dir.y):
		animConfig.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		animConfig.play("walk_front" if dir.y > 0 else "walk_down")
