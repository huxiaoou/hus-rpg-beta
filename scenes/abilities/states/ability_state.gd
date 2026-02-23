extends Node

class_name AbilityState

enum State {
    DEACTIVATED,
    AIMING,
    CASTING,
}

var state_id: State
var state_name_mapper: Dictionary = {
    State.DEACTIVATED: "Deactivated",
    State.AIMING: "Aiming",
    State.CASTING: "Casting",
}
var state_name: String


func enter() -> void:
    print("Enter %s" % state_name)
    match state_id:
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


func exit() -> void:
    print("Exit %s" % state_name)
    return
