extends PointLight2D

const SPEED = 0.01
const time_limit = 10
var destiny:Vector2
var direction:Vector2
var time_brilho = 0
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_brilho = randf_range(0, 50)
	destiny = getRandomPosition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	piscaPisca(delta)
	timer += delta
	if timer > time_limit:
		destiny = getRandomPosition()
		timer = 0
	direction = destiny - position
	position += direction * delta * SPEED
	

func getRandomPosition() -> Vector2:
	var xpos = [-50, 1100].pick_random()
	var ypos = randf_range(0.0, 600)
	return Vector2(xpos, ypos)
func piscaPisca(delta:float) -> void:
	time_brilho += delta
	energy = 0.8 + 0.4 * sin(time_brilho * 4.0)
