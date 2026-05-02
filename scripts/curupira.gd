extends CharacterBody3D

@export var spriteQuest: Texture2D

@onready var spriteNode = $lend 

func mudarEstado(questAtivada: bool):
	if questAtivada:
		spriteNode.texture = spriteQuest

func aparecer():
	show() 
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.5)
