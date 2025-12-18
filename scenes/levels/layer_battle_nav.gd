extends TileMapLayer

class_name LayerBattleNav

var astar: AStar2D = null
var datasets_grid: Dictionary[Vector2i, DataGridBattle] = { }

# ---
# cell: Vector2i, grid coordinates in tilemaplayer
# point: Vector2, position
# point = cell_to_point(cell)
# cell = global_pos_to_cell(point)


func setup() -> void:
	astar = AStar2D.new()
	astar.clear()
	add_all_points()
	update_points()
	return


func add_all_points() -> void:
	var all_used_cells: Array[Vector2i] = get_used_cells()
	for cell in all_used_cells:
		var cell_id: int = astar.get_available_point_id()
		astar.add_point(cell_id, cell_to_point(cell))

	for point_id in astar.get_point_ids():
		var cell: Vector2i = astar.get_point_position(point_id)
		var potential_cells: Array[Vector2i] = get_surrounding_cells(cell)
		var valid_neighbor_cells: Array[Vector2i] = []
		for potential_cell in potential_cells:
			if get_cell_source_id(potential_cell) != -1: # the cell is not empty
				valid_neighbor_cells.append(potential_cell)
		for valid_neighbor_cell in valid_neighbor_cells:
			var neighbor_cell_id: int = astar.get_closest_point(cell_to_point(valid_neighbor_cell))
			astar.connect_points(point_id, neighbor_cell_id)
	return


func update_points() -> void:
	for cell in get_used_cells():
		datasets_grid[cell] = DataGridBattle.new()
		if not get_cell_tile_data(cell).get_custom_data("walkable"):
			astar.set_point_disabled(astar.get_closest_point(cell))
			datasets_grid[cell].walkable = false
	return


func get_points_path(start_grid: Vector2i, end_grid: Vector2i) -> Array[Vector2]:
	# if not astar.is_in_boundsv(end_grid):
	# 	print("%s is out of reach" % end_grid)
	# 	return []
	var id_path: PackedInt64Array = astar.get_id_path(
		astar.get_closest_point(cell_to_point(start_grid)),
		astar.get_closest_point(cell_to_point(end_grid)),
	)
	var points_path: Array[Vector2] = []
	for point_id in id_path:
		points_path.append(astar.get_point_position(point_id))
	return points_path


func get_mouse_cell() -> Vector2:
	return point_to_cell(get_global_mouse_position())


func point_to_cell(point: Vector2) -> Vector2i:
	return local_to_map(to_local(point))


func cell_to_point(cell: Vector2i) -> Vector2:
	return to_global(map_to_local(cell))


func grid_is_walkable(grid: Vector2i) -> bool:
	var tile_data: TileData = get_cell_tile_data(grid)
	if tile_data:
		return tile_data.get_custom_data("walkable")
	return false
