extends Node

class_name LevelBattle

@export_group("background")
@export var bg_texture: Texture2D
@export var bg_music: AudioStream

@onready var sprite_2d_bg: Sprite2D = $Sprite2DBg
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var layer_battle_nav: LayerBattleNav = $Maps/LayerBattleNav
@onready var cell_indicator_battle: CellIndicatorBattle = $Maps/CellIndicatorBattle
@onready var unit: Unit = $Unit


func _ready() -> void:
    sprite_2d_bg.texture = bg_texture
    audio_stream_player.stream = bg_music
    audio_stream_player.play()

    ManagerCellBattle.layer_nav = layer_battle_nav
    ManagerCellBattle.layer_nav.setup()
    ManagerCellBattle.cell_indicator_battle = cell_indicator_battle
    unit.setup_in_battle()
    return
