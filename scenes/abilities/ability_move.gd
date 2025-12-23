extends Ability

class_name AbilityMove

@export var move_speed: float = 200

var target_pos: Vector2 = Vector2(0, 0)
var path_gp_points: Array[Vector2] = []


func start(start_cell: Vector2i, end_cell: Vector2i) -> void:
    if is_casting:
        print("Ability %s is casting" % short_name)
        return
    is_casting = true
    unit_owner.load_audio_stream("walk")
    unit_owner.play_animation("walk")
    path_gp_points = ManagerCellBattle.get_points_path(start_cell, end_cell)
    set_target_pos_from_path()
    adjust_animation_direction()
    return


func _process(delta: float) -> void:
    if not is_casting:
        return
    if unit_owner.position != target_pos:
        unit_owner.move_toward(target_pos, delta * move_speed)
    else:
        set_target_pos_from_path()
        adjust_animation_direction()
    return


func set_target_pos_from_path():
    if path_gp_points.is_empty():
        is_casting = false
        unit_owner.play_animation("idle")
        return
    target_pos = path_gp_points.pop_front()
    return


func adjust_animation_direction():
    if not unit_owner.adjust_animation_direction(target_pos):
        if not path_gp_points.is_empty():
            unit_owner.adjust_animation_direction(path_gp_points[-1])
    return
