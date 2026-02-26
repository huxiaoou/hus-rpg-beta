extends AbilityState

class_name AbilityStateDeactivated

func _ready() -> void:
    state = State.DEACTIVATED
    state_name = STATE_NAME_MAPPER[state]
    return


func enter() -> void:
    super.enter()
    ability.deactivate()
    return


func unhandled_input(event: InputEvent) -> void:
    if not ManagerTurnsAndRounds.is_active(ability.owner_unit):
        return
    if ability.owner_unit.is_ai():
        return
    if event.is_action_pressed(ability.key_binding):
        change_state.emit(AbilityState.State.AIMING)
        get_viewport().set_input_as_handled()
    return
