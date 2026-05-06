extends Node3D

func _ready():
	await get_tree().process_frame
	Dialogic.preload_timeline("res://timelines/caminho_casa.dtl")
	$AnimationPlayer.play("caminho_casa")
	await get_tree().create_timer(3.0).timeout
	Dialogic.start("caminho_casa")
