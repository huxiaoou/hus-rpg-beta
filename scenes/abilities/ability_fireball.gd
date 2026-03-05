extends AbilityProjectile

class_name AbilityFireball

func is_valid(cell: Vector2i) -> bool:
    if cell not in available_cells:
        return false
    var occupiant: Unit = ManagerCellBattle.get_cell_occupiant(cell)
    if occupiant == null:
        return true
    if occupiant.data.group_flag == owner_unit.data.group_flag:
        return false
    return true


func update_target_units() -> void:
    super.update_target_units()
    var units_in_range: Array = ManagerCellBattle.get_units_in_range(target_cell, 1)
    for unit in units_in_range:
        if is_legal(unit):
            target_units.append(unit)
    return


func is_legal(unit: Unit) -> bool:
    if unit.data.group_flag == DataUnit.GroupFlag.NEUTRAL:
        return false
    if unit.data.group_flag == owner_unit.data.group_flag:
        return false
    return true


func think() -> DataAiAbility:
    super.think()
    if data_ai_ability.score == 0:
        update_available_cells()
        var enemy_count: int = 0
        var best_cell: Vector2i = owner_unit.cell
        for cell: Vector2i in available_cells:
            if not is_valid(cell):
                continue
            var c: int = 0
            var units_in_range: Array = ManagerCellBattle.get_units_in_range(cell, 1)
            for unit in units_in_range:
                if is_legal(unit):
                    c += 1
            if c > enemy_count:
                best_cell = cell
                enemy_count = c
        if enemy_count > 0:
            data_ai_ability.score = enemy_count * SCORE_PER_UNIT_HIT_AOE
            data_ai_ability.targets.append(best_cell)
    print("AI thinks about ability %s, result is %s" % [short_name, data_ai_ability])
    return data_ai_ability
