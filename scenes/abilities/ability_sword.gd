extends Ability

class_name AbilitySword

@export var attack_range: int = 1
@onready var hit_effect: HitEffect = $HitEffectBlood01

var available_cells: Array[Vector2i] = []
var potential_target_cell: Vector2i
var potential_target_cell_new: Vector2i


func _ready() -> void:
    max_num_target_cells = 1
    max_num_target_units = 1
    return


func activate() -> void:
    super.activate()
    for avlb_cell: Vector2i in ManagerCellBattle.get_cells_in_range(owner_unit.cell, attack_range):
        ManagerCellBattle.set_cell_potential(avlb_cell)
        available_cells.append(avlb_cell)
        print("set %s potential white" % avlb_cell)
    potential_target_cell = available_cells[0]
    ManagerCellBattle.set_cell_focused(potential_target_cell)
    return


func deactivate() -> void:
    for cell in available_cells:
        ManagerCellBattle.set_cell_vanilla(cell)
    available_cells.clear()
    super.deactivate()
    return


func is_valid(cell: Vector2i) -> bool:
    return ManagerCellBattle.get_cell_occupiant(cell) != null and cell in available_cells


func _process(_delta: float) -> void:
    if not is_active:
        return
    if not is_casting:
        if target_cells.size() >= max_num_target_cells:
            return
        potential_target_cell_new = ManagerCellBattle.get_indicator_cell()
        if potential_target_cell != potential_target_cell_new:
            if potential_target_cell_new in available_cells:
                ManagerCellBattle.set_cell_potential(potential_target_cell)
                potential_target_cell = potential_target_cell_new
                ManagerCellBattle.set_cell_focused(potential_target_cell)
        return
    return


func launch() -> bool:
    if super.launch():
        target_units.append(ManagerCellBattle.get_cell_occupiant(target_cells[0]))
        owner_unit.adjust_animation_direction_from_cell(target_cells[0])
        owner_unit.unit_attack_impacted.connect(target_units[0].on_hurt)
        owner_unit.unit_attack_impacted.connect(hit_effect.play)
        hit_effect.set_location(ManagerCellBattle.cell_to_point(target_units[0].cell))
        owner_unit.play_animation("attack")
        await owner_unit.anim_player.animation_finished
        finish()
        return true
    return false


func finish() -> void:
    owner_unit.unit_attack_impacted.disconnect(target_units[0].on_hurt)
    owner_unit.unit_attack_impacted.disconnect(hit_effect.play)
    owner_unit.play_animation("idle")
    ManagerCellBattle.set_cell_potential(target_cells[0])
    super.finish()
    return
