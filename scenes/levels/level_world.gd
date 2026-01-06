extends Node

class_name LevelWorld

@onready var camera_controller: CameraController = $CameraController
@onready var layer_hex: LayerHexWorld = $Map/LayerHexWorld


func _ready() -> void:
    var lim_cells: Rect2i = layer_hex.get_used_rect()
    print("Left top cell = %s" % lim_cells.position)
    print("Right bottom cell = %s" % lim_cells.end)
    var left_top_pos: Vector2i = layer_hex.cell_to_point(lim_cells.position)
    var right_bottom_pos: Vector2i = layer_hex.cell_to_point(lim_cells.end)

    var tile_cell_offset: Vector2i = layer_hex.tile_set.tile_size / 2
    var camera_offset: Vector2i = camera_controller.camera_offset() * 2 as Vector2i
    var lim_left_top: Vector2i = left_top_pos + tile_cell_offset
    var lim_right_bottom: Vector2i = right_bottom_pos - tile_cell_offset - camera_offset
    camera_controller.set_camera_lim(lim_left_top, lim_right_bottom)
