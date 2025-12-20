extends Node2D

class_name Unit

@export var move_speed: float = 500

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

var is_casting: bool = false
var target_pos: Vector2 = Vector2(0, 0)
var path_gp_points: Array[Vector2] = []


func _ready() -> void:
	target_pos = position
	return


func _process(delta: float) -> void:
	if position != target_pos:
		position = position.move_toward(target_pos, delta * move_speed)
	else:
		set_target_pos_from_path()
		adjust_animation_direction()
	return


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		var start_grid: Vector2i = ManagerGridBattle.point_to_cell(position)
		var end_grid: Vector2i = ManagerGridBattle.get_mouse_cell()
		var points_path: Array[Vector2] = ManagerGridBattle.get_points_path(start_grid, end_grid)
		path_gp_points.append_array(points_path)
		set_target_pos_from_path()
		adjust_animation_direction()
	return


func set_target_pos_from_path():
	if path_gp_points.is_empty():
		return
	target_pos = path_gp_points.pop_front()
	return


func adjust_animation_direction():
	if target_pos.x > position.x:
		animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
	elif target_pos.x < position.x:
		animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
	else:
		if not path_gp_points.is_empty():
			if path_gp_points[-1].x > position.x:
				animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
			elif path_gp_points[-1].x < position.x:
				animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
	return
