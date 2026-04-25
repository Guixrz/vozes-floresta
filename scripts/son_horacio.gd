extends CharacterBody3D


@export var anim_cutscene: String = ""
@export var em_cutscene: bool = false

@onready var son: AnimatedSprite3D = $son

func _physics_process(_delta: float) -> void:
	if em_cutscene:
		if anim_cutscene == "walk":
			son.play("walk_right")
		elif anim_cutscene != "":
			son.play("idle")
		else:
			son.stop()
