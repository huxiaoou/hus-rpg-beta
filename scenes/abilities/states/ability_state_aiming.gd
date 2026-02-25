extends AbilityState

class_name AbilityStateAiming

func _ready() -> void:
    state = State.AIMING
    state_name = STATE_NAME_MAPPER[state]
    return


func enter() -> void:
    super.enter()
    ability.activate()
    if ability.owner_unit.is_enemy():
        cast_by_ai()
    return


func process(delta: float) -> void:
    ability.process_aiming(delta)
    return


func unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("left_mouse_click"):
        var new_target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
        if not ability.add_target(new_target_cell):
            if ability.try_launch():
                change_state.emit(AbilityState.State.CASTING)
    elif event.is_action_pressed("right_mouse_click"):
        if not ability.remove_target():
            change_state.emit(AbilityState.State.DEACTIVATED)
    elif event.is_action_pressed(ability.key_binding):
        print("%s has ability %s as active" % [ability.owner_unit.name, ability.short_name])
    return


func cast_by_ai() -> void:
    for new_target_cell in ability.ai_targets.targets:
        ability.add_target(new_target_cell)
    if ability.try_launch():
        change_state.emit(AbilityState.State.CASTING)
    return
