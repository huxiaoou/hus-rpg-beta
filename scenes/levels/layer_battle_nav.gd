extends TileMapLayer

class_name LayerBattleNav

func get_mouse_grid() -> Vector2:
	return global_pos_to_grid(get_global_mouse_position())


func global_pos_to_grid(global_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(global_pos))


func grid_to_global_pos(grid: Vector2i) -> Vector2:
	return to_global(map_to_local(grid))


func grid_is_walkable(grid: Vector2i) -> bool:
	var tile_data: TileData = get_cell_tile_data(grid)
	if tile_data:
		return tile_data.get_custom_data("walkable")
	return false
