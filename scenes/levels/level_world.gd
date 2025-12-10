extends Node

class_name LevelWorld

@onready var camera_controller: CameraController = $CameraController


func _ready() -> void:
	camera_controller.set_camera_lim(Vector2i(-1500, -1500), Vector2i(1500, 1500))
