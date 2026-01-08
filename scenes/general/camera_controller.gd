extends Node

class_name CameraController

@export_group("Move")
@export var init_offset: Vector2 = Vector2(1920.0 / 2, 1080.0 / 2)
@export var enable_move: bool = false
@export var move_speed: float = 500

@export_group("Trauma")
@export var decay: float = 1.618 # How fast shake fades
@export var max_offset: int = 12 # Max pixel shake
@export var trauma_power: float = 2.0 # How trauma affects intensity

@export_group("Bullet Time Effect")
@export var normal_time_scale = 1.0
@export var slow_time_scale = 0.382
@export var slow_duration = 0.15 # The duration of the slow motion effect in seconds
@export var fade_duration = 0.15 # The fade duration to smoothly transition back to normal speed

@onready var camera_2d: Camera2D = $Camera2D

# move
var lim_left_top: Vector2 = Vector2(-1920.0 / 2, -1080.0 / 2)
var lim_right_down: Vector2 = Vector2(1920.0 / 2, 1080.0 / 2)
var target_position: Vector2

# trauma
var trauma = 0.0


func _ready() -> void:
    camera_2d.offset = init_offset


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
    shake(delta)
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


func apply_trauma(amount: float = 1.0) -> void:
    camera_2d.make_current()
    trauma = min(1.0, trauma + amount) # <= 1.0
    return


func apply_bullet_time() -> void:
    if Engine.time_scale != normal_time_scale:
        Engine.time_scale = normal_time_scale
    var tween = create_tween()
    Engine.time_scale = slow_time_scale
    tween.tween_interval(slow_duration) # Wait for the specified duration
    tween.tween_property(Engine, "time_scale", normal_time_scale, fade_duration)
    return


func shake(delta: float) -> void:
    var delta_offset: Vector2 = Vector2.ZERO
    if trauma > 0:
        trauma -= decay * delta
        var shake_intensity: float = pow(trauma, trauma_power) * max_offset
        delta_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
    camera_2d.offset = init_offset + delta_offset
    return


func on_unit_attack_impacted(_unit: Unit) -> void:
    apply_trauma()
    apply_bullet_time()
    return
