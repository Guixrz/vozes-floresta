extends CharacterBody3D


var SPEED:float = 1.5
@onready var animConfig:AnimatedSprite3D = $animator3D_sprite
enum {
	WALKING, IDLE
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement()

func movement() -> void:
	var horizontalVel:int  = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var verticalVel:int  = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	var modVel:float =  sqrt(pow(horizontalVel, 2) + pow(verticalVel, 2))
	var vector_dir = Vector2(horizontalVel, verticalVel)
	if modVel != 0:
		velocity.x = horizontalVel * SPEED/modVel
		velocity.z = verticalVel * SPEED/modVel
		move_and_slide()
	#de acordo com a direçao do vetor, anima
	if modVel != 0:
		animationLogic(WALKING, vector_dir)
	else:
		animationLogic(IDLE, vector_dir)
	
func animationLogic(state, vec) -> void:
	match state:
		WALKING:
				if vec.is_equal_approx(Vector2(0, 1)):
					animConfig.play("walk_front")
				if vec.is_equal_approx(Vector2(0, -1)):
					animConfig.play("walk_down")
				if vec.is_equal_approx(Vector2(1, 0)):
					animConfig.play("walk_right")
				if vec.is_equal_approx(Vector2(-1, 0)):
					animConfig.play("walk_left")
		IDLE:
			animConfig.stop()
