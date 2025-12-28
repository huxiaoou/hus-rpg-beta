extends AbilityState

func enter() -> void:
    ability.deactivate()
    return


func exit() -> void:
    ability.activate()
    return
