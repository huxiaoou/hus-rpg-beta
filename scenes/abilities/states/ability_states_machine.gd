extends Node

class_name AbilityStatesMachine

@export var init_state: AbilityState.State = AbilityState.State.DEACTIVATED
var curr_state: AbilityState = null
var states: Dictionary[AbilityState.State, AbilityState] = { }


# ---- State machine ----
func setup(ability: Ability) -> void:
    for state: AbilityState in get_children():
        state.setup(ability)
        states[state.state] = state
        state.change_state.connect(on_change_state)
    curr_state = states[init_state]
    curr_state.enter()
    return


func _process(delta: float) -> void:
    if curr_state:
        curr_state.process(delta)
    return


func _physics_process(delta: float) -> void:
    if curr_state:
        curr_state.physics_process(delta)
    return


func _unhandled_input(event: InputEvent) -> void:
    if curr_state:
        curr_state.unhandled_input(event)
    return


func on_change_state(state: AbilityState.State) -> void:
    var new_state: AbilityState = states.get(state)
    curr_state.exit()
    curr_state = new_state
    curr_state.enter()
    return


func activate_by_ai(ai_targets: AIDataAbilityTargets) -> void:
    if curr_state.state == AbilityState.State.DEACTIVATED:
        curr_state.cast_by_ai(ai_targets)
    return
