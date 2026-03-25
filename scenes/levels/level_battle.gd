extends Node

class_name LevelBattle

@export_group("Background")
@export var bg_texture: Texture2D
@export var bg_music: AudioStream

@export_group("UI")
@export var scene_ui_avatar: PackedScene

@onready var sprite_2d_bg: Sprite2D = $Sprite2DBg
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var layer_battle_nav: LayerBattleNav = $Maps/LayerBattleNav
@onready var cell_indicator_battle: CellIndicatorBattle = $Maps/CellIndicatorBattle
@onready var unit_viking: Unit = $Units/UnitViking
@onready var unit_skull: Unit = $Units/UnitSkull
@onready var units_group: Node = $Units
@onready var camera_controller: CameraController = $CameraController
@onready var v_box_avatars: VBoxContainer = $CanvasLayer/VBoxAvatars
@onready var ui_turn_cards_deck: UITurnCardsDeck = $CanvasLayer/UITurnCardsDeck


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
        unit.hurt_box.damage_taken.connect(camera_controller.on_unit_attack_impacted)
        if unit.is_ally():
            var ui_avatar: UIAvatar = scene_ui_avatar.instantiate()
            v_box_avatars.add_child(ui_avatar)
            ui_avatar.init_from_unit(unit)
    return


func _ready() -> void:
    sprite_2d_bg.texture = bg_texture
    audio_stream_player.stream = bg_music
    audio_stream_player.play()
    var units: Array[Unit] = get_units()
    init_units(units)
    ManagerTurnsAndRounds.setup(units, ui_turn_cards_deck)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("quick_save"):
        save_game()
    elif event.is_action_pressed("quick_load"):
        load_game()
    return


func save_game() -> void:
    var save_data: DataSave = DataSave.new()
    for unit in get_units():
        save_data.units[unit.data.name] = unit.data

    var error: int = ResourceSaver.save(save_data, "user://save_game.tres")
    if error != OK:
        print("[ERR] Failed to save game: %d" % error)
    else:
        print("Game saved")
    return


func load_game() -> void:
    if FileAccess.file_exists("user://save_game.tres"):
        var loaded_resource: DataSave = ResourceLoader.load(
            "user://save_game.tres",
            "DataSave",
            ResourceLoader.CACHE_MODE_IGNORE,
        )
        if loaded_resource:
            for unit_name in loaded_resource.units:
                print("unit:%s" % unit_name)
                
            var current_units: Array[Unit] = get_units()
            for unit in current_units:
                var data: DataUnit = loaded_resource.units[unit.data.name]
                if data:
                    unit.data = data
                    unit.cell = data.cell
    print("Game loaded")
    return
