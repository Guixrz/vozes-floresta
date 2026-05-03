extends CanvasLayer

func _ready():
	$AnimationPlayer.play("ir_jogo")
	await $AnimationPlayer.animation_finished
	Dialogic.start("zoios")
	await Dialogic.timeline_ended
	disparar_transicao_para_o_jogo()
	
func disparar_transicao_para_o_jogo():
	TransitionLendas.fade_to_scene("res://scenes/root_world.tscn")
