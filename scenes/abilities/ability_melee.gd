extends Ability

class_name AbilityMelee

@onready var hit_effect: HitEffect = $HitEffect

func _ready() -> void:
    super._ready()
    max_num_target_cells = 1
    max_num_target_units = 1
    return


func is_valid(cell: Vector2i) -> bool:
    return ManagerCellBattle.get_cell_occupiant(cell) != null and cell in available_cells


func process_aiming(_delta: float) -> void:
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


func on_melee_weapon_impacted() -> void:
    owner_unit.activate_hit_box()
    target_unit.activate_hurt_box()
    owner_unit.hit_box.global_position = target_unit.global_position
    hit_effect.set_location(target_unit.global_position)
    hit_effect.play_main()
    return


func launch() -> void:
    super.launch()
    target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
    owner_unit.adjust_animation_direction_from_cell(target_cell)
    owner_unit.melee_weapon_impacted.connect(on_melee_weapon_impacted)
    owner_unit.update_hit_box()
    owner_unit.play_animation("melee_attack")
    await owner_unit.anim_player.animation_finished
    finish()
    return


func finish() -> void:
    owner_unit.melee_weapon_impacted.disconnect(on_melee_weapon_impacted)
    owner_unit.deactivate_hit_box()
    target_unit.deactivate_hurt_box()
    owner_unit.hit_box.global_position = owner_unit.global_position
    owner_unit.play_animation("idle")
    super.finish()
    return


func think() -> DataAiAbility:
    super.think()
    if data_ai_ability.score == 0:
        update_available_cells()
        var min_health: float = INF
        var best_cell: Vector2i = owner_unit.cell
        for cell: Vector2i in available_cells:
            if not is_valid(cell):
                continue
            var unit: Unit = ManagerCellBattle.get_cell_occupiant(cell)
            if unit.data.group_flag == owner_unit.data.group_flag:
                continue
            var h: float = unit.data.health
            if h < min_health:
                best_cell = cell
                min_health = h
        if min_health < INF:
            data_ai_ability.score = 20
            data_ai_ability.targets.append(best_cell)
    print("AI thinks about ability %s, result is %s" % [short_name, data_ai_ability])
    return data_ai_ability
