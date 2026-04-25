extends MeshInstance3D

@export var fade_duration: float = 3.0
@export var hidden_duration: float = 10
@export var visible_duration: float = 5

var material_ref: StandardMaterial3D

func _ready():
	material_ref = get_active_material(0).duplicate()
	set_surface_override_material(0, material_ref)

	material_ref.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	start_cycle()


func start_cycle() -> void:
	while true:
		await fade_in()
		await get_tree().create_timer(visible_duration).timeout
		await fade_out()
		await get_tree().create_timer(hidden_duration).timeout


func fade_in() -> void:
	var elapsed := 0.0
	
	while elapsed < fade_duration:
		var alpha = elapsed / fade_duration
		set_alpha(alpha)
		
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	set_alpha(1.0)


func fade_out() -> void:
	var elapsed := 0.0
	
	while elapsed < fade_duration:
		var alpha = 1.0 - (elapsed / fade_duration)
		set_alpha(alpha)
		
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	set_alpha(0.0)


func set_alpha(value: float) -> void:
	var color = material_ref.albedo_color
	color.a = value
	material_ref.albedo_color = color
