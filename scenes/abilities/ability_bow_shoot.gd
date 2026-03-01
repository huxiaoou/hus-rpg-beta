extends AbilityProjectile

class_name AbilityBowShoot

func is_valid(cell: Vector2i) -> bool:
    return ManagerCellBattle.get_cell_occupiant(cell) != null and cell in available_cells


func update_target_units() -> void:
    super.update_target_units()
    target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
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
