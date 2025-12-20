extends TileMapLayer

class_name LayerBattleNav

var astar: AStar2D = null
var datasets_cells: Dictionary[Vector2i, DataCellBattle] = { }

# ---
# cell: Vector2i, cell coordinates in tilemaplayer
# point: Vector2, position
# point = cell_to_point(cell)
# cell = global_pos_to_cell(point)
# cells:Vector2i are used as points in AStar


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
		astar.add_point(cell_id, cell)

	for point_id in astar.get_point_ids():
		var cell: Vector2i = astar.get_point_position(point_id)
		var potential_cells: Array[Vector2i] = get_surrounding_cells(cell)
		var valid_neighbor_cells: Array[Vector2i] = []
		for potential_cell in potential_cells:
			if not cell_is_empty(potential_cell):
				valid_neighbor_cells.append(potential_cell)
		for valid_neighbor_cell in valid_neighbor_cells:
			var neighbor_cell_id: int = astar.get_closest_point(valid_neighbor_cell)
			astar.connect_points(point_id, neighbor_cell_id)
	return


func update_points() -> void:
	for cell in get_used_cells():
		datasets_cells[cell] = DataCellBattle.new()
		if not cell_is_walkable(cell):
			astar.set_point_disabled(astar.get_closest_point(cell))
			datasets_cells[cell].walkable = false
	return


func get_cells_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
	var start_point_id: int = astar.get_closest_point(start_cell)
	var end_point_id: int = astar.get_closest_point(end_cell)
	if end_cell.distance_to(astar.get_point_position(end_point_id)) > 1e-2:
		print("Target cell is not in battle.")
		return []

	var id_path: PackedInt64Array = astar.get_id_path(start_point_id, end_point_id)
	var cells_path: Array[Vector2i] = []
	for point_id in id_path:
		cells_path.append(astar.get_point_position(point_id) as Vector2i)
	print(cells_path)
	return cells_path


func get_points_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
	var cells_path: Array[Vector2i] = get_cells_path(start_cell, end_cell)
	var points_path: Array[Vector2] = []
	for cell: Vector2i in cells_path:
		points_path.append(cell_to_point(cell))
	return points_path


func cell_is_empty(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) == -1


func get_mouse_cell() -> Vector2:
	return point_to_cell(get_global_mouse_position())


func point_to_cell(point: Vector2) -> Vector2i:
	return local_to_map(to_local(point))


func cell_to_point(cell: Vector2i) -> Vector2:
	return to_global(map_to_local(cell))


func cell_is_walkable(cell: Vector2i) -> bool:
	var tile_data: TileData = get_cell_tile_data(cell)
	if tile_data:
		return tile_data.get_custom_data("walkable")
	return false
