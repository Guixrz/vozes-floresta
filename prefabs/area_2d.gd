extends Area2D

@export var timeline_name : String = "interacao"
@export var offset_position : Vector2 = Vector2(0,-20)
var prompt = null
var player_inside = false
var tween : Tween

func _ready():
	prompt = get_node_or_null("../caixa2")
	if prompt == null:
		push_error("Nó 'caixa' não encontrado!")
	else:
		prompt.scale = Vector2.ZERO

func _show_prompt():
	if tween:
		tween.kill()
	prompt.visible = true
	tween = get_tree().create_tween()
	tween.tween_property(prompt, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK)

func _hide_prompt():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(prompt, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK)
	await tween.finished
	prompt.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside = true
		_show_prompt()

func _process(delta):
	var bodies = get_overlapping_bodies()
	var player_found = false
	for body in bodies:
		if body is Player:
			player_found = true
			break
			
	if player_inside and not player_found:
		player_inside = false
		_hide_prompt()
	
	if player_inside and Input.is_action_just_pressed("interact"):
		if Dialogic.current_timeline == null:
			player_inside = false
			_hide_prompt()
			await get_tree().create_timer(0.2).timeout
			Dialogic.start(timeline_name)
