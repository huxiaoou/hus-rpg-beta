extends Parallax2D

class_name ParallaxBgLayer

@onready var sprite_2d: Sprite2D = $Sprite2D

func setup(texture: Texture2D, _scroll_scale: Vector2,  _repeat_size: Vector2 = Vector2(1920, 0),  _repeat_times:int =5) -> void:
	sprite_2d.texture = texture
	scroll_scale = _scroll_scale
	repeat_size = _repeat_size
	repeat_times = _repeat_times
	sprite_2d.position = get_viewport().size / 2
	return
