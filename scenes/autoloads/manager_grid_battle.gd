extends Node

var layer_nav: LayerBattleNav


func get_mouse_cell() -> Vector2:
	return layer_nav.get_mouse_cell()


func point_to_cell(global_pos: Vector2) -> Vector2i:
	return layer_nav.point_to_cell(global_pos)


func cell_to_point(grid: Vector2i) -> Vector2:
	return layer_nav.cell_to_point(grid)


func grid_is_walkable(grid: Vector2i) -> bool:
	return layer_nav.grid_is_walkable(grid)


func get_points_path(start_grid: Vector2i, end_grid: Vector2i) -> Array[Vector2]:
	return layer_nav.get_points_path(start_grid, end_grid)
