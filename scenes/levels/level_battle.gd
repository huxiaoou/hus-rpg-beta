extends Node

class_name LevelBattle

@export_group("background")
@export var bg_texture: Texture2D
@export var bg_music: AudioStream

@onready var sprite_2d_bg: Sprite2D = $Sprite2DBg
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var layer_battle_nav: LayerBattleNav = $Maps/LayerBattleNav
@onready var cell_indicator_battle: CellIndicatorBattle = $Maps/CellIndicatorBattle
@onready var unit_viking: Unit = $Units/UnitViking
@onready var unit_skull: Unit = $Units/UnitSkull
@onready var units_group: Node = $Units
@onready var camera_controller: CameraController = $CameraController


func get_units() -> Array[Unit]:
    var units: Array[Unit] = []
    for child: Variant in units_group.get_children():
        if not is_instance_of(child, Unit):
            print("[WRN] %s is not a Unit" % (child as Node).name)
            continue
        units.append(child)
    return units


func init_units(units: Array[Unit]) -> void:
    for unit in units:
        unit.setup_in_battle()
        unit.unit_attack_impacted.connect(camera_controller.on_unit_attack_impacted)
        ManagerCellBattle.disable_cell(unit.cell, unit)
    return


func _ready() -> void:
    sprite_2d_bg.texture = bg_texture
    audio_stream_player.stream = bg_music
    audio_stream_player.play()

    ManagerCellBattle.layer_nav = layer_battle_nav
    ManagerCellBattle.layer_nav.setup()
    ManagerCellBattle.cell_indicator_battle = cell_indicator_battle
    var units: Array[Unit] = get_units()
    init_units(units)
    ManagerTurnsAndRounds.setup(units)
    return
