extends Node

class_name CameraController

@export_group("camera")
@export var enable_move: bool = false
@export var move_speed: float = 500

@onready var camera_2d: Camera2D = $Camera2D

var lim_left_top: Vector2 = Vector2(-1920.0 / 2, -1080.0 / 2)
var lim_right_down: Vector2 = Vector2(1920.0 / 2, 1080.0 / 2)
var target_position: Vector2


func set_camera_lim(left_top: Vector2, right_down: Vector2) -> void:
    lim_left_top = left_top
    lim_right_down = right_down
    return


func _process(delta: float) -> void:
    if enable_move:
        var camera_mov_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
        if camera_mov_direction != Vector2.ZERO:
            target_position = camera_2d.global_position + camera_mov_direction * move_speed * delta
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


func camera_offset() -> Vector2:
    return camera_2d.offset
