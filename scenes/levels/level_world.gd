extends Node

class_name LevelWorld

@onready var camera_controller: CameraController = $CameraController
@onready var layer_hex: LayerHex = $Map/LayerHex


func _ready() -> void:
	var lim_cells: Rect2i = layer_hex.get_used_rect()
	print(lim_cells.position)
	print(lim_cells.end)
	var left_top_pos: Vector2i = layer_hex.grid_to_global_pos(lim_cells.position)
	var right_bottom_pos: Vector2i = layer_hex.grid_to_global_pos(lim_cells.end)
	camera_controller.set_camera_lim(left_top_pos + get_viewport().size / 2, right_bottom_pos - get_viewport().size /2)
