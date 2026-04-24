extends CharacterBody3D

@export var anim_cutscene: String = ""
@export var em_cutscene: bool = false
@export var SPEED: float = 2.5

@onready var animConfig: AnimatedSprite3D = $animator3D_sprite

func _physics_process(_delta: float) -> void:
	if em_cutscene:
		if anim_cutscene != "":
			animConfig.play("walk_right")
		else:
			animConfig.stop()
		return # impede o movimento manual via teclado
	
	handle_movement()

func handle_movement() -> void:
	# input.get_vector já lida com as 4 teclas e normaliza a diagonal automaticamente
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		velocity.x = input_dir.x * SPEED
		velocity.z = input_dir.y * SPEED # no 3D, o 'Y' do input vai para o 'Z'
		move_and_slide()
		update_animation(input_dir)
	else:
		animConfig.stop()

func update_animation(dir: Vector2) -> void:
	#prioriza a direção com maior valor de input
	if abs(dir.x) > abs(dir.y):
		animConfig.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		animConfig.play("walk_front" if dir.y > 0 else "walk_down")
func setInCutScene(condition:bool) -> void:
	em_cutscene = condition
