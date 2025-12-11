extends TileMapLayer

class_name LayerHex

enum { TILE_MODULATE_FULL, TILE_MODULATE_TRANS }
var cur_grid: Vector2i = Vector2i(0, 0)
var new_grid: Vector2i = Vector2i(0, 0)


func _process(_delta: float) -> void:
	var mouse_global_pos: Vector2 = get_global_mouse_position()
	new_grid = global_pos_to_grid(mouse_global_pos)
	if new_grid != cur_grid:
		update_lower_grids_alpha(cur_grid, TILE_MODULATE_FULL)
		update_lower_grids_alpha(new_grid, TILE_MODULATE_TRANS)
		cur_grid = new_grid
		print(cur_grid)


func get_offset_left(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + Vector2i(-1, 0) * size


func get_offset_right(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + Vector2i(1, 0) * size


func get_offset_left_upper(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + (Vector2i(-1, -1) if grid.y % 2 == 0 else Vector2i(0, -1)) * size


func get_offset_left_lower(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + (Vector2i(-1, 1) if grid.y % 2 == 0 else Vector2i(0, 1)) * size


func get_offset_right_upper(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + (Vector2i(0, -1) if grid.y % 2 == 0 else Vector2i(1, -1)) * size


func get_offset_right_lower(grid: Vector2i, size: int = 1) -> Vector2i:
	return grid + (Vector2i(0, 1) if grid.y % 2 == 0 else Vector2i(1, 1)) * size


func global_pos_to_grid(global_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(global_pos))


func grid_to_global_pos(grid: Vector2i) -> Vector2:
	return to_global(map_to_local(grid))


func update_lower_grids_alpha(grid: Vector2i, alternative: int) -> void:
	set_grid_alpha(get_offset_left_lower(grid), alternative)
	set_grid_alpha(get_offset_right_lower(grid), alternative)
	return


func set_grid_alpha(grid: Vector2i, alternative: int) -> void:
	var data: TileData = self.get_cell_tile_data(grid)
	if data:
		if data.get_custom_data("cross_hex"):
			set_cell(grid, get_cell_source_id(grid), get_cell_atlas_coords(grid), alternative)
	return
