extends Button

class_name ButtonUI

var is_focused: bool = false


func _on_mouse_entered() -> void:
    grab_focus()
    is_focused = true
    return


func _input(event: InputEvent) -> void:
    if event is not InputEventMouseMotion:
        return

    var mouse_pos: Vector2 = get_global_mouse_position()
    if is_focused:
        return
    if mouse_pos.y > global_position.y + size.y:
        return
    if mouse_pos.y < global_position.y:
        return
    grab_focus()
    is_focused = true
    return


func _on_focus_exited() -> void:
    is_focused = false
    return
