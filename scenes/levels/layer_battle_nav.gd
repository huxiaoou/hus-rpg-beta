extends TileMapLayer

class_name LayerBattleNav

var astar: AStarGrid2D = AStarGrid2D.new()


func setup() -> void:
	astar.region = get_used_rect()
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	return


func get_grids_path(start_grid: Vector2i, end_grid: Vector2i) -> Array[Vector2i]:
	if not astar.is_in_boundsv(end_grid):
		return []
	return astar.get_id_path(start_grid, end_grid, true)

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
