extends Area3D

func _on_body_entered(body: Node3D) -> void:
	# Verifica se quem entrou foi o player
	if body.has_method("handle_movement"): 
		# 1. Para o personagem usando a sua variável
		body.em_cutscene = true
		body.velocity = Vector3.ZERO # Garante que ele pare imediatamente
		
		# 2. Mostra o balão (supondo que o nome no Player seja 'Pensamento')
		var balao = body.get_node("Pensamento")
		balao.visible = true
		
		# 3. Espera 3 segundos (Timer rápido via código)
		await get_tree().create_timer(3.0).timeout
		
		# 4. Esconde o balão e libera o personagem
		balao.visible = false
		body.em_cutscene = false
		
		# 5. (Opcional) Empurra o player um pouco para trás 
		# para ele não ficar "preso" dentro da área ativando o sinal de novo
		body.global_position.z += 1.0
