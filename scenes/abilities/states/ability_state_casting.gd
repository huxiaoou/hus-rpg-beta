extends AbilityState

class_name AbilityStateCasting

func _ready() -> void:
    state_id = State.CASTING
    state_name = state_name_mapper[state_id]
    return


func enter() -> void:
    super.enter()
    return


func process(_delta: float) -> void:
    pass


func physics_process(_delta: float) -> void:
    pass


func exit() -> void:
    super.exit()
    return
