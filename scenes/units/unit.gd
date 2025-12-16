extends Node2D

@export var move_speed: float = 500

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D

var is_casting: bool = false
var target_pos: Vector2 = Vector2(0, 0)

func _ready() -> void:
	target_pos = position
	return

func _process(delta: float) -> void:
	if target_pos == null:
		return
	if position != target_pos:
		position = position.move_toward(target_pos, delta * move_speed)
	return

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		target_pos = get_global_mouse_position()
	return
