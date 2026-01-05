extends Node

var layer_nav: LayerBattleNav
var cell_indicator_battle: CellIndicatorBattle


func get_mouse_cell() -> Vector2i:
    return layer_nav.get_mouse_cell()


func get_indicator_cell() -> Vector2i:
    return cell_indicator_battle.indicator_cell


func point_to_cell(global_pos: Vector2) -> Vector2i:
    return layer_nav.point_to_cell(global_pos)


func cell_to_point(cell: Vector2i) -> Vector2:
    return layer_nav.cell_to_point(cell)


func cell_is_walkable(cell: Vector2i) -> bool:
    return layer_nav.cell_is_walkable(cell)


func get_points_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
    return layer_nav.get_points_path(start_cell, end_cell)


func get_cells_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
    return layer_nav.get_cells_path(start_cell, end_cell)


func set_cell_vanilla(cell: Vector2i) -> void:
    layer_nav.set_cell_vanilla(cell)
    return


func set_cell_yellow(cell: Vector2i) -> void:
    layer_nav.set_cell_yellow(cell)
    return


func set_cell_green(cell: Vector2i) -> void:
    layer_nav.set_cell_green(cell)
    return


func set_cell_target(cell: Vector2i) -> void:
    layer_nav.set_cell_target(cell)
    return


func set_cell_potential(cell: Vector2i) -> void:
    layer_nav.set_cell_potential(cell)
    return


func set_cell_cyan(cell: Vector2i) -> void:
    layer_nav.set_cell_cyan(cell)
    return


func get_cells_by_range(cell: Vector2i, rng: int = 0) -> Dictionary[int, Array]:
    return layer_nav.get_cells_by_range(cell, rng)


func get_cells_in_range(cell: Vector2i, rng: int = 0) -> Array[Vector2i]:
    return layer_nav.get_cells_in_range(cell, rng)


func disable_cell(cell: Vector2i, unit: Unit) -> void:
    layer_nav.disable_cell(cell, unit)
    return


func enable_cell(cell: Vector2i) -> void:
    layer_nav.enable_cell(cell)
    return


func cell_is_reachable(cell: Vector2i) -> bool:
    return layer_nav.cell_is_reachable(cell)


func get_cell_occupiant(cell: Vector2i) -> Unit:
    return layer_nav.get_cell_occupiant(cell)
