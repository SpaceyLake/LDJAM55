extends Area2D

var accessable = false
@onready var selection_wheel = $SelectionWheel
@onready var graphics = $Graphics
@export var eldriches: Array[PackedScene]

func _ready():
	selection_wheel.option_selected.connect(end_summoning)
	(graphics.material as ShaderMaterial).set_shader_parameter("speed", 0)
	pass

func end_summoning(eldrich_id):
	(graphics.material as ShaderMaterial).set_shader_parameter("speed", 0)
	if eldrich_id == 0:
		return
	var eldirch = eldriches[eldrich_id - 1].instantiate()
	get_parent().add_child(eldirch)
	eldirch.global_position = self.global_position

func _input(event):
	if accessable and event.is_action_pressed("interact"):
		(graphics.material as ShaderMaterial).set_shader_parameter("speed", 1)
		selection_wheel.open()

func _on_area_entered(_area):
	accessable = true

func _on_area_exited(_area):
	accessable = false