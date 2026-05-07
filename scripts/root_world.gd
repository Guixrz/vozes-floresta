extends Node3D

@onready var player = $player
@onready var passarinho = $bird 
@onready var arrowSound = $CanvasLayer/indication 

var missao_passarinho_ativa = false

func _ready() -> void:
	# Começa com a seta desligada
	arrowSound.visible = false
	
	# conecta os sinais do passarinho para reagir aqui no mundo principal
	if passarinho:
		passarinho.piou.connect(_on_passarinho_piou)
		passarinho.silenciou.connect(_on_passarinho_silenciou)
		passarinho.passarinho_salvo.connect(_on_passarinho_salvo)

func _process(_delta: float) -> void:
	# calcula a rotação da seta se ela estiver visível na tela
	if not arrowSound.visible or not is_instance_valid(passarinho) or not player:
		return
		
	var cam = get_viewport().get_camera_3d()
	if not cam:
		return
		
	# direção horizontal do player até o passarinho
	var dir_ao_alvo = (passarinho.global_position - player.global_position)
	dir_ao_alvo.y = 0
	dir_ao_alvo = dir_ao_alvo.normalized()
	
	# direção que a câmera está olhando
	var cam_frente = -cam.global_transform.basis.z
	cam_frente.y = 0
	cam_frente = cam_frente.normalized()
	
	# angulo entre a câmera e o alvo
	var angulo = cam_frente.signed_angle_to(dir_ao_alvo, Vector3.UP)
	
	# gira a seta de UI
	arrowSound.rotation = -angulo

func iniciar_missao_resgate():
	missao_passarinho_ativa = true
	
	# verifica se o passarinho existe e acorda ele
	if is_instance_valid(passarinho):
		passarinho.iniciar_procura()
	print("Missão iniciada! Procure pelo passaro.")

# sinais que o passarinho emite e a root_world escuta
func _on_passarinho_piou():
	if missao_passarinho_ativa:
		arrowSound.visible = true

func _on_passarinho_silenciou():
	arrowSound.visible = false

func _on_passarinho_salvo():
	missao_passarinho_ativa = false
	arrowSound.visible = false
	print("o passarinho foi salvo")

# Adicione isso no seu root_world.gd

func _unhandled_input(event: InputEvent) -> void:
	# Se você pressionar a tecla "P" no teclado durante o jogo:
	if event is InputEventKey and event.pressed and event.keycode == KEY_P:
		print("DEBUG: Forçando início da missão do passarinho!")
		iniciar_missao_resgate()
