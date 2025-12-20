extends Node

class_name LevelWorld

@onready var camera_controller: CameraController = $CameraController
@onready var layer_hex: LayerHexWorld = $Map/LayerHexWorld


func _ready() -> void:
	var lim_cells: Rect2i = layer_hex.get_used_rect()
	print(lim_cells.position)
	print(lim_cells.end)
	var left_top_pos: Vector2i = layer_hex.cell_to_point(lim_cells.position)
	var right_bottom_pos: Vector2i = layer_hex.cell_to_point(lim_cells.end)
	var lim_left_top: Vector2i = left_top_pos + layer_hex.tile_set.tile_size / 2 + get_viewport().size / 2
	var lim_right_bottom: Vector2i = right_bottom_pos - layer_hex.tile_set.tile_size / 2 - get_viewport().size / 2
	camera_controller.set_camera_lim(lim_left_top, lim_right_bottom)
