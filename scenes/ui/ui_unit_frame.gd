extends Control

class_name UIUnitFrame

@onready var unit_avatar: TextureButton = $Control/UnitAvatar

func set_avatar(avatar: Texture2D) -> void:
    unit_avatar.texture_normal = avatar
