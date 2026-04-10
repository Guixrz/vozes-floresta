extends Camera3D

@export var target: Node3D

#varia de 0 a 1
var weightLerpCam:float = 0.3
var offsetZ:float = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	#calculos fisicos bem minimos quero aq
	lerpCam()

func lerpCam() -> void:
	position.x = lerpf(position.x , target.position.x, weightLerpCam)
	position.z = lerpf(position.z, target.position.z + offsetZ, weightLerpCam)
