extends HBoxContainer

class_name UIStatus

@export var custom_icon: Texture
@onready var icon: TextureRect = $Icon

        

func _ready() -> void:
    icon.texture = custom_icon
