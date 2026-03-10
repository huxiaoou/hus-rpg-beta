extends AbilityState

class_name AbilityStateDeactivated

func _ready() -> void:
    state = State.DEACTIVATED
    state_name = STATE_NAME_MAPPER[state]
    return


func enter() -> void:
    # super.enter()
    ability.deactivate()
    return


func unhandled_input(event: InputEvent) -> void:
    if not ManagerTurnsAndRounds.is_active(ability.owner_unit):
        return
    if ability.owner_unit.is_ai():
        return
    if event.is_action_pressed(ability.key_binding):
        if ability.owner_unit.mgr_abilities.has_ability_selected():
            ability.audio_player.play_warning()
            print("%s has ability %s as active" % [ability.owner_unit.name, ability.short_name])
            return
        change_state.emit(AbilityState.State.AIMING)
        get_viewport().set_input_as_handled()
    return
