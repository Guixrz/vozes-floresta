extends Node

func definir_animacao_caminhada(player: Node3D, target_pos: Vector3) -> void:
	var animator = player.get_node_or_null("animator3D_sprite")
	if not animator: return
		
	var direcao = (target_pos - player.global_position)
	direcao.y = 0
	direcao = direcao.normalized()
	
	if abs(direcao.x) > abs(direcao.z):
		animator.play("walk_right" if direcao.x > 0 else "walk_left")
	else:
		animator.play("walk_front" if direcao.z > 0 else "walk_down")
