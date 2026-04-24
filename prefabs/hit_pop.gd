extends Area2D

@export var dialog_texts : Array[String] = []
@export var offset_position : Vector2 = Vector2(0,-20)

var prompt = null
var player_inside = false
var tween : Tween

func _ready():
	prompt = get_node_or_null("../caixa")
	if prompt == null:
		push_error("Nó 'caixinha' não encontrado!")
	else:
		prompt.scale = Vector2.ZERO  # começa invisível

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
	if player_inside and bodies.size() == 0:
		player_inside = false
		_hide_prompt()
	if player_inside and Input.is_action_just_pressed("interact"):
		player_inside = false
		_hide_prompt()
		await get_tree().create_timer(0.2).timeout
		DialogManager.start_dialog(dialog_texts, global_position + offset_position)
		
		
