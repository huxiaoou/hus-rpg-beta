extends Node

class_name LevelSidescroll

@export_category("Side Scroll")
@export var lim_left: int = 0
@export var lim_right: int = 0

@onready var camera_controller: CameraController = $CameraController


func _ready() -> void:
	camera_controller.set_camera_lim(Vector2i(lim_left, 0), Vector2i(lim_right, 0))
