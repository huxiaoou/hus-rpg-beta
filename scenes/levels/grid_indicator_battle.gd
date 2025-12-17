extends Node2D

class_name GridIndicatorBattle

var mouse_grid: Vector2i = Vector2i.ZERO


func _process(_delta: float) -> void:
	var new_mouse_grid: Vector2i = ManagerGridBattle.get_mouse_grid()
	if new_mouse_grid == mouse_grid:
		return
	if !ManagerGridBattle.grid_is_walkable(new_mouse_grid):
		return
	mouse_grid = new_mouse_grid
	global_position = ManagerGridBattle.grid_to_global_pos(mouse_grid)
	print("Enter Grid (%d, %d)" % [mouse_grid.x, mouse_grid.y])
	return
