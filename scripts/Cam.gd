extends Camera3D

@export var target: Node3D #player
var player:Node3D
@export var child: Node3D #filho


var weightLerpCam:float = 2# var q segue o player lentamente, talvez precise de melhora no futuro
#bom, tah vendo esse offset? se a camera ficar -90 (olhando pro chao, entao ele deve ser 0, se a camera for inclinada, uns 5 ou menos ta  bom)
var offsetZ:float = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pq target já começa com  REF DO PLyer
	player = target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	#calculos fisicos bem minimos quero aq
	lerpCam(delta)

func lerpCam(delta:float) -> void:
	#essa funcao deve ser provisoria, ta muito simples esse smooth e o efeito nao eh muito perceptivel
	position.x = lerpf(position.x ,target.position.x, weightLerpCam * delta)
	position.z = lerpf(position.z, target.position.z + offsetZ, weightLerpCam * delta)

#ao inves de animar a camera pra seguir um personagem, só mudar por aq
func setTarget(who: String):
	if who == "child":
		target = child
	elif who == "player":
		target = player
