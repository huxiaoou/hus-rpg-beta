extends Ability

class_name AbilitySword

@export var attack_range: int = 2

var available_cells: Array[Vector2i] = []
var potential_target_cell: Vector2i
var potential_target_cell_new: Vector2i


func _ready() -> void:
    max_num_target_cells = 1
    max_num_target_units = 0
    return


func activate() -> void:
    super.activate()
    for avlb_cell: Vector2i in ManagerCellBattle.get_cells_in_range(owner_unit.cell, attack_range):
        if ManagerCellBattle.cell_is_walkable(avlb_cell):
            ManagerCellBattle.set_cell_gray(avlb_cell)
            available_cells.append(avlb_cell)
    return


func deactivate() -> void:
    for cell in available_cells:
        ManagerCellBattle.set_cell_white(cell)
    available_cells.clear()
    super.deactivate()
    return


func _process(_delta: float) -> void:
    if not is_active:
        return
    if not is_casting:
        if target_cells.size() >= max_num_target_cells:
            return
        potential_target_cell_new = ManagerCellBattle.get_indicator_cell()
        if potential_target_cell != potential_target_cell_new:
            if potential_target_cell_new in available_cells:
                ManagerCellBattle.set_cell_gray(potential_target_cell)
                potential_target_cell = potential_target_cell_new
                ManagerCellBattle.set_cell_yellow(potential_target_cell)
        return
    return


func launch() -> bool:
    if super.launch():
        owner_unit.play_animation("attack")
        await owner_unit.anim_player.animation_finished
        finish()
        return true
    return false


func finish() -> void:
    owner_unit.play_animation("idle")
    ManagerCellBattle.set_cell_gray(target_cells[0])
    super.finish()
    return
