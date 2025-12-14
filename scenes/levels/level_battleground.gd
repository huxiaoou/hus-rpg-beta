extends Node

class_name LevelBattleground

@export_group("background")
@export var bg_texture: Texture2D
@export var bg_music: AudioStream

@onready var sprite_2d_bg: Sprite2D = $Sprite2DBg
@onready var camera_controller: CameraController = $CameraController
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	camera_controller.set_camera_lim(Vector2(0, 0), Vector2(0, 0))
	sprite_2d_bg.texture = bg_texture
	audio_stream_player.stream = bg_music
	audio_stream_player.play()
	return
