extends Node3D

@onready var player = $player
@onready var passarinho = $bird 

var missao_passarinho_ativa = false

func _ready() -> void:
	if passarinho:
		passarinho.passarinho_salvo.connect(_on_passarinho_salvo)


func iniciar_missao_resgate():
	missao_passarinho_ativa = true
	if is_instance_valid(passarinho):
		passarinho.iniciar_procura()
	print("Missão iniciada! Ouça atentamente os piados.")

func _on_passarinho_salvo():
	missao_passarinho_ativa = false
	print("O passarinho foi salvo!")

# tecla de debug para testar rápido
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		iniciar_missao_resgate()
