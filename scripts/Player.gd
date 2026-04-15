extends CharacterBody3D

class_name PlayerClass
#caracteristicas
var SPEED:float = 5
var lifePlayer:float = 100
var isRunning:bool = false
var isAttacking:bool = false
var vector_dir:Vector2
#objetos
@onready var animConfig:AnimatedSprite3D = $animator3D_sprite
@onready var stateConfig:Node3D = $statesController




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#dou a referencia a este objeto e aos seus estados
	stateConfig.giveInfo(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement()
	defineStates()
	
	
func defineStates() -> void:
	#nesse caso aqui, a classe stateMachine vai desativar o booleano
	if Input.is_action_just_pressed("attack") and not isAttacking:
		isAttacking = true
	if Input.is_action_just_pressed("run"):
		isRunning = !isRunning
		print("correndo")
func movement() -> void:
	var horizontalVel:int  = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	var verticalVel:int  = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	var modVel:float =  sqrt(pow(horizontalVel, 2) + pow(verticalVel, 2))
	vector_dir = Vector2(horizontalVel, verticalVel)
	if isRunning:
		SPEED = 6
	else:
		SPEED = 4
	if modVel != 0:
		velocity.x = horizontalVel * SPEED/modVel
		velocity.z = verticalVel * SPEED/modVel
		move_and_slide()
	
