extends Ability

class_name AbilityMove

@export var move_speed: float = 120

var potential_path_cells: Array[Vector2i] = []
var potential_path_cells_new: Array[Vector2i] = []
var start_cell: Vector2i
var end_cell: Vector2i
var target_pos_in_path: Vector2 = Vector2(0, 0)
var path_gp_points: Array[Vector2] = []


func _ready() -> void:
    max_num_target_cells = 1
    max_num_target_units = 0
    return


func recolor_potential_path_cells() -> void:
    for cell: Vector2i in potential_path_cells:
        ManagerCellBattle.set_cell_path(cell)
    return


func clear_potential_path_cells() -> void:
    for cell: Vector2i in potential_path_cells:
        ManagerCellBattle.set_cell_vanilla(cell)
    potential_path_cells.clear()
    return


func is_valid(cell: Vector2i) -> bool:
    return ManagerCellBattle.cell_is_reachable(cell) and cell in available_cells


func _process(delta: float) -> void:
    if not is_active:
        return
    if not is_casting:
        if target_cells.size() >= max_num_target_cells:
            return
        potential_target_cell_new = ManagerCellBattle.get_indicator_cell()
        if potential_target_cell_new not in available_cells:
            return
        if potential_target_cell != potential_target_cell_new:
            potential_target_cell = ManagerCellBattle.get_indicator_cell()
            potential_path_cells_new = ManagerCellBattle.get_cells_path(
                owner_unit.cell,
                potential_target_cell,
            )
            for cell in potential_path_cells:
                if cell not in potential_path_cells_new:
                    ManagerCellBattle.set_cell_potential(cell)
            for cell in potential_path_cells_new:
                if cell not in potential_path_cells:
                    ManagerCellBattle.set_cell_path(cell)
            potential_path_cells = potential_path_cells_new
        return
    if owner_unit.position != target_pos_in_path:
        owner_unit.move_toward(target_pos_in_path, delta * move_speed)
    else:
        set_target_pos_from_path()
        adjust_animation_direction()
    return


func launch() -> bool:
    if super.launch():
        clear_available_cells()
        recolor_potential_path_cells()
        start_cell = owner_unit.cell
        end_cell = target_cell
        selected.emit()
        owner_unit.play_animation("walk")
        path_gp_points = ManagerCellBattle.get_points_path(start_cell, end_cell)
        ManagerCellBattle.enable_cell(start_cell)
        ManagerCellBattle.disable_cell(end_cell, owner_unit)
        set_target_pos_from_path()
        adjust_animation_direction()
        return true
    return false


func finish() -> void:
    owner_unit.play_animation("idle")
    clear_potential_path_cells()
    super.finish()
    return


func set_target_pos_from_path():
    ManagerCellBattle.set_cell_vanilla(ManagerCellBattle.point_to_cell(target_pos_in_path))
    if path_gp_points.is_empty():
        finish()
        return
    target_pos_in_path = path_gp_points.pop_front()
    return


func adjust_animation_direction():
    if not owner_unit.adjust_animation_direction(target_pos_in_path):
        if not path_gp_points.is_empty():
            owner_unit.adjust_animation_direction(path_gp_points[-1])
    return
