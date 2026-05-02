extends Area3D

@onready var luz = $OmniLight3D

func _ready():
	# Conecta o sinal de quando algum corpo entra na área
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
		if body.name == "player":
			# Cria um Tween para animar os valores suavemente
			var tween = create_tween()
			
			# Anima a Luz para energia 1.5 (acesa) em 1 segundo
			tween.parallel().tween_property(luz, "light_energy", 1.25, 1.0)
			
			# Opcional: Depois de uns segundos, apagar a luz para economizar performance
			tween.tween_property(luz, "light_energy", 0.0, 2.0).set_delay(5.0)
