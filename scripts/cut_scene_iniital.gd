extends CanvasLayer

func _ready():
	$AnimationPlayer.play("ir_jogo")
	await $AnimationPlayer.animation_finished
	Dialogic.start("zoios")
	await Dialogic.timeline_ended
	TransitionLendas.fade_to_scene("res://scenes/root_world.tscn")
