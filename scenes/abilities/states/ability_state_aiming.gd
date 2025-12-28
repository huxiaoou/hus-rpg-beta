extends AbilityState

func enter() -> void:
    ability.activate()
    return


func exit() -> void:
    pass


func process(_delta: float) -> void:
    pass


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("left_mouse_click"):
        if ability.targets_are_full():
            ability.change_state("Casting")
        else:
            ability.add_target_cell()
    elif event.is_action_pressed("right_mouse_click"):
        if ability.has_targets():
            ability.drop_target_cell()
        else:
            if ability.is_casting:
                ability.warning_is_casting()
            else:
                ability.change_state("Deactive")
    return
