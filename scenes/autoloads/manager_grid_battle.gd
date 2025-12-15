extends Node

var layer_nav: LayerBattleNav


func get_mouse_grid() -> Vector2:
	return layer_nav.get_mouse_grid()


func global_pos_to_grid(global_pos: Vector2) -> Vector2i:
	return layer_nav.global_pos_to_grid(global_pos)


func grid_to_global_pos(grid: Vector2i) -> Vector2:
	return layer_nav.grid_to_global_pos(grid)

func grid_is_walkable(grid: Vector2i) -> bool:
	return layer_nav.grid_is_walkable(grid)
