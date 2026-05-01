extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		show()


func _on_resume_button_down() -> void:
	hide()


func _on_exit_button_down() -> void:
	get_tree().quit()
