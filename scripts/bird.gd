extends CharacterBody3D

@onready var som = $sound
@onready var area_resgate = $rescueArea

signal piou
signal silenciou
signal passarinho_salvo

func _ready():
	area_resgate.body_entered.connect(_on_rescue_area_body_entered)
	som.finished.connect(_on_som_finished)

func _on_timer_timeout():
	if som and not som.playing:
		som.play()
		piou.emit()

func _on_som_finished():
	silenciou.emit()

func _on_rescue_area_body_entered(body: Node3D):
	if body.is_in_group("player") or body.name.to_lower().contains("player"):
		salvar_passarinho()

func salvar_passarinho():
	som.stop()
	silenciou.emit()
	area_resgate.queue_free()
	passarinho_salvo.emit()
	queue_free()

func iniciar_procura():
	show()                # torna o passarinho visível no mapa
	$Timer.start()
