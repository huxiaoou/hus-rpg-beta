extends HBoxContainer

class_name UIStatus

@export var custom_icon: Texture
@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label

        

func _ready() -> void:
    icon.texture = custom_icon

func set_value(value: float) -> void:
    label.text = "%d" % value
