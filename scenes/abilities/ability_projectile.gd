extends Ability

class_name AbilityProjectile

@export_group("Projectile")
@export var curve_scale: float = 0.00
@export var scene_projectile: PackedScene

@onready var comp_track_drawer: CompTrackDrawer = $CompTrackDrawer


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
        var start: Vector2 = owner_unit.global_position
        var end: Vector2 = ManagerCellBattle.cell_to_point(potential_target_cell)
        var control: Vector2 = Utils.cal_control_point_for_bezier(start, end, curve_scale)
        comp_track_drawer.update_points(start, control, end)
    return


func on_ranged_projectile_launched() -> void:
    var projectile: Projectile = scene_projectile.instantiate()
    add_child(projectile)
    await projectile.launch(owner_unit, target_unit, curve_scale)
    return


func launch() -> void:
    super.launch()
    target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
    owner_unit.adjust_animation_direction_from_cell(target_cell)
    owner_unit.ranged_projectile_launched.connect(on_ranged_projectile_launched)
    owner_unit.update_hit_box()
    owner_unit.play_animation("ranged_attack")
    await owner_unit.anim_player.animation_finished
    finish()
    return


func finish() -> void:
    owner_unit.ranged_projectile_launched.disconnect(on_ranged_projectile_launched)
    comp_track_drawer.clear_points()
    owner_unit.play_animation("idle")
    super.finish()
    return


func deactivate() -> void:
    comp_track_drawer.clear_points()
    super.deactivate()
    return


func think() -> DataAiAbility:
    var posssible_data_ai_ability: DataAiAbility = super.think()
    if posssible_data_ai_ability.score == 0:
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
            posssible_data_ai_ability.score = 20
            posssible_data_ai_ability.targets.append(best_cell)
    print("AI thinks about ability %s, result is %s" % [short_name, posssible_data_ai_ability])
    return posssible_data_ai_ability
