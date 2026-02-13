extends Ability

class_name AbilityProjectile

@export_group("Projectile")
@export var curve_scale: float = 0.05

@onready var hit_effect: HitEffect = $HitEffectBlood06
@onready var comp_track_drawer: CompTrackDrawer = $CompTrackDrawer

var scene_projectile: PackedScene = preload("res://scenes/weapons/projectile.tscn")


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
            var start: Vector2 = owner_unit.global_position
            var end: Vector2 = ManagerCellBattle.cell_to_point(potential_target_cell)
            var control: Vector2 = Utils.cal_control_point_for_bezier(start, end, curve_scale)
            comp_track_drawer.update_points(start, control, end)
        return
    return


func launch() -> bool:
    if super.launch():
        target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
        owner_unit.adjust_animation_direction_from_cell(target_cell)
        var projectile: Projectile = scene_projectile.instantiate()
        add_child(projectile)
        projectile.impacted.connect(target_unit.on_hurt)
        projectile.impacted.connect(hit_effect.play)
        hit_effect.set_location(target_unit.global_position)
        owner_unit.play_animation("attack")
        await owner_unit.anim_player.animation_finished
        await projectile.launch(owner_unit, target_unit, curve_scale)
        finish()
        return true
    return false


func finish() -> void:
    comp_track_drawer.clear_points()
    owner_unit.play_animation("idle")
    super.finish()
    return
