extends Node3D

#nao usar a referencia do state config, please
#não defina valores a referencia do player aq
enum State {
	WALKING, IDLE, RUNNING, ATTACKING, DAMAGED, DEATH
}
var is_damaged:bool
var actualState = State.IDLE
var past_state = null
var player:PlayerClass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		defineState()
		match actualState:
			State.WALKING:
				walk()
			State.IDLE:
				idle()
			State.RUNNING:
				running()
			State.ATTACKING:
				attack()
			State.DAMAGED:
				pass
			State.DEATH:
				pass
		#debug
		#print(str(State.keys()[actualState]))
	

func defineState() -> void:
	if player.lifePlayer > 0:
		if player.vector_dir.length() > 0:
			if player.isRunning:
				actualState = State.RUNNING
			else:
				actualState = State.WALKING
		else: 
			actualState = State.IDLE
	else:
		actualState = State.DEATH
		
func walk() -> void:
	if player.vector_dir.is_equal_approx(Vector2(0, 1)):
		player.animConfig.play("walk_front")
	if player.vector_dir.is_equal_approx(Vector2(0, -1)):
		player.animConfig.play("walk_down")
	if player.vector_dir.is_equal_approx(Vector2(1, 0)):
		player.animConfig.play("walk_right")
	if player.vector_dir.is_equal_approx(Vector2(-1, 0)):
		player.animConfig.play("walk_left")
func idle()->void:
	player.animConfig.stop()
func running() -> void:
	pass
	
func attack()-> void:
	pass
func giveInfo(ref:PlayerClass) -> void:
	player = ref
