extends Ability

class_name AbilityMove

@export var move_speed: float = 120

var target_pos: Vector2 = Vector2(0, 0)
var path_gp_points: Array[Vector2] = []


func start(start_cell: Vector2i, end_cell: Vector2i) -> void:
    if is_casting:
        print("Ability %s is casting" % short_name)
        return
    super.start(start_cell, end_cell)
    is_casting = true
    owner_unit.load_audio_stream("walk")
    owner_unit.play_animation("walk")
    path_gp_points = ManagerCellBattle.get_points_path(start_cell, end_cell)
    set_target_pos_from_path()
    adjust_animation_direction()
    return


func _process(delta: float) -> void:
    if not is_casting:
        return
    if owner_unit.position != target_pos:
        owner_unit.move_toward(target_pos, delta * move_speed)
    else:
        set_target_pos_from_path()
        adjust_animation_direction()
    return


func set_target_pos_from_path():
    if path_gp_points.is_empty():
        is_casting = false
        owner_unit.play_animation("idle")
        return
    target_pos = path_gp_points.pop_front()
    return


func adjust_animation_direction():
    if not owner_unit.adjust_animation_direction(target_pos):
        if not path_gp_points.is_empty():
            owner_unit.adjust_animation_direction(path_gp_points[-1])
    return
