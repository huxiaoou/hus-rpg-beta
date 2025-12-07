extends Node

class_name CameraController

@export var camera_move_speed: float = 500

@onready var camera_2d: Camera2D = $Camera2D

func _process(delta: float) -> void:
	var camera_mov_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if camera_mov_direction != Vector2.ZERO:
		camera_2d.global_position = camera_2d.global_position + camera_mov_direction * camera_move_speed * delta
	return
