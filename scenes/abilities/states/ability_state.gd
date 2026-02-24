extends Node

class_name AbilityState

const STATE_NAME_MAPPER: Dictionary = {
    State.DEACTIVATED: "Deactivated",
    State.AIMING: "Aiming",
    State.CASTING: "Casting",
}

enum State {
    DEACTIVATED,
    AIMING,
    CASTING,
}

var state: State
var state_name: String
var ability: Ability = null

signal change_state(state: State)


func setup(_ability: Ability) -> void:
    ability = _ability
    return


func enter() -> void:
    print("Enter %s" % state_name)
    match state:
        State.DEACTIVATED:
            pass
        State.AIMING:
            pass
        State.CASTING:
            pass
        _:
            pass
    return


func process(_delta: float) -> void:
    pass


func physics_process(_delta: float) -> void:
    pass


func unhandled_input(_event: InputEvent) -> void:
    pass


func exit() -> void:
    print("Exit %s" % state_name)
    return
