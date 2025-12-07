extends TileMapLayer

class_name LayerHex

var cur_grid: Vector2i = Vector2i(0, 0)
var new_grid: Vector2i = Vector2i(0, 0)


func _process(_delta: float) -> void:
	var mouse_global_pos: Vector2 = get_global_mouse_position()
	new_grid = global_pos_to_grid(mouse_global_pos)
	if new_grid != cur_grid:
		update_lower_grids_alpha(cur_grid, 1.0)
		update_lower_grids_alpha(new_grid, 0.5)
		cur_grid = new_grid
		print(cur_grid)


func global_pos_to_grid(global_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(global_pos))


func update_lower_grids_alpha(grid: Vector2i, alpha: float) -> void:
	set_grid_alpha(grid + Vector2i(0, 1), alpha)
	set_grid_alpha(grid + Vector2i(-1, 1), alpha)
	return


func set_grid_alpha(grid: Vector2i, alpha: float) -> void:
	var data: TileData = self.get_cell_tile_data(grid)
	if data:
		if data.get_custom_data("cross_hex"):
			data.modulate.a = alpha
	return
