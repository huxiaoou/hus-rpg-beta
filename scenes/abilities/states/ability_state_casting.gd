extends AbilityState

class_name AbilityStateCasting

func _ready() -> void:
    state = State.CASTING
    state_name = STATE_NAME_MAPPER[state]
    return


func enter() -> void:
    super.enter()
    ability.casting_finished.connect(on_casting_finished)
    ability.launch()
    return


func process(delta: float) -> void:
    ability.process_casting(delta)
    return


func on_casting_finished() -> void:
    ability.casting_finished.disconnect(on_casting_finished)
    change_state.emit(AbilityState.State.DEACTIVATED)
    return


func unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(ability.key_binding):
        print("%s has ability %s as active" % [ability.owner_unit.name, ability.short_name])
    return
