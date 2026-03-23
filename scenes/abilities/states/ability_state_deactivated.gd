extends AbilityState

class_name AbilityStateDeactivated

func _ready() -> void:
    state = State.DEACTIVATED
    state_name = STATE_NAME_MAPPER[state]
    return


func enter() -> void:
    # super.enter()
    ability.deactivate()
    if ability.ui_button:
        ability.ui_button.set_deactivated()
    return


func exit() -> void:
    if ability.ui_button:
        ability.ui_button.set_activated()
    super.exit()
    return


func on_ui_pressed() -> void:
    if not ManagerTurnsAndRounds.is_active(ability.owner_unit):
        return
    if ability.owner_unit.is_ai():
        return
    if ability.owner_unit.mgr_abilities.has_ability_selected():
        ability.audio_player.play_warning()
        ability.owner_unit.mgr_abilities.show_active_ability()
        return
    change_state.emit(AbilityState.State.AIMING)
    return
