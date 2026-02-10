extends Ability

class_name AbilityProjectile

@onready var hit_effect: HitEffect = $HitEffectBlood06

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
        return
    return


func launch() -> bool:
    if super.launch():
        target_units.append(ManagerCellBattle.get_cell_occupiant(target_cell))
        owner_unit.adjust_animation_direction_from_cell(target_cell)
        var projectile: Projectile = scene_projectile.instantiate()
        add_child(projectile)
        projectile.global_position = owner_unit.global_position
        projectile.impacted.connect(target_unit.on_hurt)
        projectile.impacted.connect(hit_effect.play)
        hit_effect.set_location(target_unit.position)
        var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
        tw.tween_property(projectile, "global_position", target_unit.global_position, 2.0)
        owner_unit.play_animation("attack")
        await owner_unit.anim_player.animation_finished
        await tw.finished
        projectile.queue_free()
        finish()
        return true
    return false


func finish() -> void:
    owner_unit.play_animation("idle")
    super.finish()
    return
