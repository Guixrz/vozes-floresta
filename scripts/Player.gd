extends CharacterBody3D

var SPEED:float = 1.5

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
	
	if modVel != 0:
		velocity.x = horizontalVel * SPEED/modVel
		velocity.z = verticalVel * SPEED/modVel
		move_and_slide()
	
