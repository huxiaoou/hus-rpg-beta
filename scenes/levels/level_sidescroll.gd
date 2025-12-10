extends Node

class_name LevelSidescroll

@export_category("Side Scroll")
@export var lim_left: float = 0
@export var lim_right: float = 0

@onready var camera_controller: CameraController = $CameraController


func _ready() -> void:
	camera_controller.set_camera_lim(Vector2(lim_left, 0), Vector2(lim_right, 0))
