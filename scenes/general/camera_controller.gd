extends Node

class_name CameraController

@export var camera_move_speed: float = 500

@onready var camera_2d: Camera2D = $Camera2D

var lim_left_top: Vector2i = Vector2i(-1920 % 2, -1080 % 2)
var lim_right_down: Vector2i = Vector2i(1920 % 2, 1080 % 2)
var target_position: Vector2


func set_camera_lim(left_top: Vector2i, right_down: Vector2i) -> void:
	lim_left_top = left_top
	lim_right_down = right_down


func _process(delta: float) -> void:
	var camera_mov_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if camera_mov_direction != Vector2.ZERO:
		target_position = camera_2d.global_position + camera_mov_direction * camera_move_speed * delta
	clamp_target_pos()
	track_target_pos()
	return


func clamp_target_pos() -> void:
	target_position.x = clamp(target_position.x, lim_left_top.x, lim_right_down.x)
	target_position.y = clamp(target_position.y, lim_left_top.y, lim_right_down.y)
	return


func track_target_pos() -> void:
	camera_2d.global_position = target_position
	return
