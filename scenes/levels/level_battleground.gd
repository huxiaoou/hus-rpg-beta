extends Node

class_name LevelBattleground

@export_group("background")
@export var bg_texture: Texture2D
@export var bg_music: AudioStream

@onready var sprite_2d_bg: Sprite2D = $Sprite2DBg
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var layer_battle_nav: LayerBattleNav = $Maps/LayerBattleNav

func _ready() -> void:
	sprite_2d_bg.texture = bg_texture
	audio_stream_player.stream = bg_music
	audio_stream_player.play()
	
	ManagerGridBattle.layer_nav = layer_battle_nav
	return
