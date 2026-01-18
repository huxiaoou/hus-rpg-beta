extends Control

class_name UIAvatar2

@export var avatar: Texture2D

@onready var ui_unit_frame: UIUnitFrame = $UIUnitFrame
@onready var ui_bar_health: UIDualProgressBar = $UIBarHealth
@onready var ui_bar_magicka: UIDualProgressBar = $UIBarMagicka
@onready var ui_level: UILevel = $UILevel

func _ready() -> void:
    ui_unit_frame.set_avatar(avatar)
    return
    
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("test_add"):
        ui_bar_health.on_value_changed(ui_bar_health.dual_pb_val + 10)
        ui_bar_magicka.on_value_changed(ui_bar_magicka.dual_pb_val + 5)
    elif event.is_action_pressed("test_subtract"):
        ui_bar_health.on_value_changed(ui_bar_health.dual_pb_val - 10)
        ui_bar_magicka.on_value_changed(ui_bar_magicka.dual_pb_val - 5)
    return
