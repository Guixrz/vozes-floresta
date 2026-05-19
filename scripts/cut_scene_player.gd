extends Node3D

func _ready():
	DialogicUtil.get_style_by_name("semperfil.tres").prepare()
	DialogicUtil.get_style_by_name("estilo.tres").prepare()
	DialogicUtil.get_style_by_name("estiloinimigo.tres").prepare()
	DialogicUtil.get_style_by_name("horaciojunior.tres").prepare()
	await get_tree().process_frame
	Dialogic.preload_timeline("res://timelines/caminho_casa.dtl")
	$AnimationPlayer.play("caminho_casa")
	
	await get_tree().create_timer(3.0).timeout
	
	Dialogic.start("caminho_casa")
	
	
func go_to_initial_cutscene() -> void:
	TransitionLendas.fade_to_scene("res://scenes/cut_scene_inital.tscn")
