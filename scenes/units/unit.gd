extends Node2D

@export var move_speed: float = 500

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D

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
	return


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		var start_grid: Vector2i = ManagerGridBattle.global_pos_to_grid(position)
		var end_grid: Vector2i = ManagerGridBattle.global_pos_to_grid(get_global_mouse_position())
		var path_grids: Array[Vector2i] = ManagerGridBattle.get_grids_path(start_grid, end_grid)
		print(path_grids)
		for grid: Vector2i in path_grids:
			var gp_point: Vector2 = ManagerGridBattle.grid_to_global_pos(grid)
			path_gp_points.append(gp_point)
		set_target_pos_from_path()
	return


func set_target_pos_from_path():
	if path_gp_points.is_empty():
		return
	target_pos = path_gp_points.pop_front()
	return
