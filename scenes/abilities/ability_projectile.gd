extends Ability

class_name AbilityProjectile

signal hit_effect_applied()

@export_group("Projectile")
@export var curve_scale: float = 0.00
@export var scene_projectile: PackedScene

@onready var comp_track_drawer: CompTrackDrawer = $CompTrackDrawer


func _ready() -> void:
    super._ready()
    max_num_target_cells = 1
    max_num_target_units = 1
    return


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
    await projectile.launch(owner_unit, target_cell, target_units, curve_scale, hit_effect_applied)
    return


func update_target_units() -> void:
    target_units.clear()
    return


func launch() -> void:
    super.launch()
    update_target_units()
    ManagerCamera.move_to_between(owner_unit.global_position, ManagerCellBattle.cell_to_point(target_cell))
    owner_unit.adjust_animation_direction_from_cell(target_cell)
    owner_unit.ranged_projectile_launched.connect(on_ranged_projectile_launched)
    owner_unit.update_hit_box()
    owner_unit.play_animation("ranged_attack")
    await hit_effect_applied
    finish()
    return


func finish() -> void:
    ManagerCamera.reset_to_init_status()
    owner_unit.ranged_projectile_launched.disconnect(on_ranged_projectile_launched)
    comp_track_drawer.clear_points()
    owner_unit.play_animation("idle")
    super.finish()
    return


func deactivate() -> void:
    comp_track_drawer.clear_points()
    super.deactivate()
    return
