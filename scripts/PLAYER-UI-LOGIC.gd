extends CanvasLayer

@onready var uicontrol = $ui_control
@onready var animNode = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_bestiary() -> void:
	uicontrol.showBestiaryBtn()


func _on_ui_control_book_enters(condiction:bool) -> void:
	print("animando")
	if condiction:
		animNode.play("bookFadeIn")
	else:
		animNode.play_backwards("bookFadeIn")
	
