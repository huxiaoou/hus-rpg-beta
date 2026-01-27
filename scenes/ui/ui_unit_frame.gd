extends Control

class_name UIUnitFrame

signal unit_frame_double_clicked()

@onready var unit: TextureRect = $Unit

func set_avatar(avatar: Texture2D) -> void:
    unit.texture = avatar


func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            if event.double_click:
                unit_frame_double_clicked.emit()
                print("Double clicked")
    return
