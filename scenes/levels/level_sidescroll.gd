extends Node

class_name LevelSideScroll

@export_group("Side Scroll")
@export var lim_left: float = 0
@export var lim_right: float = 0

@export_group("Textures")
@export var parallax_backgrounds_textures: Array[Texture2D]

@onready var camera_controller: CameraController = $CameraController
@onready var parallax_bg: ParallaxBg = $ParallaxBg


func _ready() -> void:
	camera_controller.set_camera_lim(Vector2(lim_left, 0), Vector2(lim_right, 0))
	parallax_bg.setup(parallax_backgrounds_textures)
