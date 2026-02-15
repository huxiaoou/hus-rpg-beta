extends Ability

class_name AbilitySword

@onready var hit_effect: HitEffect = $HitEffectBlood06


func _ready() -> void:
    max_num_target_cells = 1
    max_num_target_units = 1
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
        if potential_target_cell_new not in available_cells:
            return
        if potential_target_cell != potential_target_cell_new:
            ManagerCellBattle.set_cell_potential(potential_target_cell)
            potential_target_cell = potential_target_cell_new
            ManagerCellBattle.set_cell_focused(potential_target_cell)
        return
    return


func launch() -> bool:
    if super.launch():
        target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
        owner_unit.adjust_animation_direction_from_cell(target_cell)
        # owner_unit.unit_attack_impacted.connect(target_unit.on_hurt)
        # owner_unit.unit_attack_impacted.connect(hit_effect.play)
        hit_effect.set_location(target_unit.position)
        owner_unit.update_hit_box()
        owner_unit.play_animation("attack")
        await owner_unit.anim_player.animation_finished
        finish()
        return true
    return false


func finish() -> void:
    #owner_unit.unit_attack_impacted.disconnect(target_unit.on_hurt)
    #owner_unit.unit_attack_impacted.disconnect(hit_effect.play)
    owner_unit.play_animation("idle")
    super.finish()
    return
