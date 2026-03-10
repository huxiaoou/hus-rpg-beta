extends Node

var layer_nav: LayerBattleNav
var cell_indicator_battle: CellIndicatorBattle

const ERROR_VECTOR2I: Vector2i = -999 * Vector2i.ONE
const ERROR_VECTOR2: Vector2 = -999 * Vector2.ONE


func get_mouse_cell() -> Vector2i:
    if layer_nav:
        return layer_nav.get_mouse_cell()
    return ERROR_VECTOR2I


func get_indicator_cell() -> Vector2i:
    if cell_indicator_battle:
        return cell_indicator_battle.indicator_cell
    return ERROR_VECTOR2I


func point_to_cell(global_pos: Vector2) -> Vector2i:
    if layer_nav:
        return layer_nav.point_to_cell(global_pos)
    return ERROR_VECTOR2I


func cell_to_point(cell: Vector2i) -> Vector2:
    if layer_nav:
        return layer_nav.cell_to_point(cell)
    return ERROR_VECTOR2


func cell_is_walkable(cell: Vector2i) -> bool:
    if layer_nav:
        return layer_nav.cell_is_walkable(cell)
    return false


func get_points_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2]:
    if layer_nav:
        return layer_nav.get_points_path(start_cell, end_cell)
    return []


func get_cells_path(start_cell: Vector2i, end_cell: Vector2i) -> Array[Vector2i]:
    if layer_nav:
        return layer_nav.get_cells_path(start_cell, end_cell)
    return []


func set_cell_vanilla(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_vanilla(cell)
    return


func set_cell_focused(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_focused(cell)
    return


func set_cell_green(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_green(cell)
    return


func set_cell_target(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_target(cell)
    return


func set_cell_potential(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_potential(cell)
    return


func set_cell_path(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.set_cell_path(cell)
    return


func get_cells_by_range(cell: Vector2i, rng: int = 0) -> Dictionary[int, Array]:
    if layer_nav:
        return layer_nav.get_cells_by_range(cell, rng)
    return { }


func get_cells_in_range(cell: Vector2i, rng: int = 0) -> Array[Vector2i]:
    if layer_nav:
        return layer_nav.get_cells_in_range(cell, rng)
    return []


func get_units_in_range(cell: Vector2i, rng: int = 1) -> Array[Unit]:
    if layer_nav:
        return layer_nav.get_units_in_range(cell, rng)
    return []


func disable_cell(cell: Vector2i, unit: Unit) -> void:
    if layer_nav:
        layer_nav.disable_cell(cell, unit)
    return


func enable_cell(cell: Vector2i) -> void:
    if layer_nav:
        layer_nav.enable_cell(cell)
    return


func cell_is_reachable(cell: Vector2i) -> bool:
    if layer_nav:
        return layer_nav.cell_is_reachable(cell)
    return false


func get_cell_occupiant(cell: Vector2i) -> Unit:
    if layer_nav:
        return layer_nav.get_cell_occupiant(cell)
    return null
