extends Ability

class_name AbilityMove

@export var move_speed: float = 120

var potential_target_cell: Vector2i
var potential_path_cells: Array[Vector2i] = []
var potential_path_cells_new: Array[Vector2i] = []
var start_cell: Vector2i
var end_cell: Vector2i
var target_pos: Vector2 = Vector2(0, 0)
var path_gp_points: Array[Vector2] = []


func _ready() -> void:
    max_num_target_cells = 1
    max_num_target_units = 0
    return


func launch() -> bool:
    if super.launch():
        start_cell = owner_unit.cell
        end_cell = target_cells[0]
        selected.emit()
        is_casting = true
        owner_unit.load_audio_stream("walk")
        owner_unit.play_animation("walk")
        path_gp_points = ManagerCellBattle.get_points_path(start_cell, end_cell)
        set_target_pos_from_path()
        adjust_animation_direction()
        return true
    return false


func deactivate() -> void:
    for cell in potential_path_cells:
        ManagerCellBattle.set_cell_white(cell)
    potential_path_cells.clear()
    super.deactivate()
    return


func _process(delta: float) -> void:
    if not is_active:
        return
    if not is_casting:
        if target_cells.size() >= max_num_target_cells:
            return
        if potential_target_cell != ManagerCellBattle.get_indicator_cell():
            potential_target_cell = ManagerCellBattle.get_indicator_cell()
            potential_path_cells_new = ManagerCellBattle.get_cells_path(owner_unit.cell, potential_target_cell)
            for cell in potential_path_cells:
                if cell not in potential_path_cells_new:
                    ManagerCellBattle.set_cell_white(cell)
            for cell in potential_path_cells_new:
                if cell not in potential_path_cells:
                    ManagerCellBattle.set_cell_gray(cell)
            potential_path_cells = potential_path_cells_new
        return
    if owner_unit.position != target_pos:
        owner_unit.move_toward(target_pos, delta * move_speed)
    else:
        set_target_pos_from_path()
        adjust_animation_direction()
    return


func finish() -> void:
    owner_unit.play_animation("idle")
    potential_path_cells.clear()
    ManagerCellBattle.set_cell_white(target_cells[0])
    super.finish()
    return


func set_target_pos_from_path():
    ManagerCellBattle.set_cell_white(ManagerCellBattle.point_to_cell(target_pos))
    if path_gp_points.is_empty():
        finish()
        return
    target_pos = path_gp_points.pop_front()
    return


func adjust_animation_direction():
    if not owner_unit.adjust_animation_direction(target_pos):
        if not path_gp_points.is_empty():
            owner_unit.adjust_animation_direction(path_gp_points[-1])
    return
