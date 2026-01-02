extends Node2D

class_name Unit

enum GroupFlag {
    ALLY,
    ENEMY,
    NEUTRAL,
}

@export_group("Attributes")
@export var initiative: int = 12
@export var group_flag: GroupFlag = GroupFlag.NEUTRAL

@export_group("Init")
@export var init_cell: Vector2i

@export_group("Audios")
@export var astream_walk: AudioStream

@onready var sprite_body: AnimatedSprite2D = $CharacterBody2D/SpriteBody
@onready var sprite_shadow: AnimatedSprite2D = $CharacterBody2D/SpriteShadow
@onready var sfx_player: AudioStreamPlayer2D = $CharacterBody2D/SfxPlayer
@onready var anim_player: AnimationPlayer = $CharacterBody2D/AnimPlayer
@onready var mgr_abilities: ManagerAbilities = $ManagerAbilities

var astreams: Dictionary[String, AudioStream] = { }
var cell: Vector2i:
    get:
        return ManagerCellBattle.point_to_cell(position)
    set(value):
        position = ManagerCellBattle.cell_to_point(value)


static func sort_by_initiative(a: Unit, b: Unit) -> bool:
    if a.initiative == b.initiative:
        if a.group_flag == b.group_flag:
            return true
        return a.group_flag < b.group_flag
    return a.initiative > b.initiative


func _ready() -> void:
    mgr_abilities.setup(self)
    setup_astreams()
    play_animation("idle")
    return


func setup_astreams() -> void:
    astreams["walk"] = astream_walk
    return


func setup_in_battle() -> void:
    cell = init_cell
    return


func load_audio_stream(astream_name: String) -> void:
    var astream_to_load: AudioStream = astreams[astream_name]
    if sfx_player.stream != astream_to_load:
        sfx_player.stop()
        sfx_player.stream = astream_to_load
        return


func move_toward(target_pos: Vector2, distance: float) -> void:
    position = position.move_toward(target_pos, distance)
    return


func _unhandled_input(event: InputEvent) -> void:
    if not ManagerTurnsAndRounds.is_active(self):
        return

    if event.is_action_pressed("ability_1"):
        if mgr_abilities.is_active:
            mgr_abilities.show_active_ability()
            return
        mgr_abilities.activiate_ability("ability_move")
    elif event.is_action_pressed("ability_2"):
        if mgr_abilities.is_active:
            mgr_abilities.show_active_ability()
            return
        mgr_abilities.activiate_ability("ability_sword")
    return


func adjust_animation_direction(target_pos: Vector2) -> bool:
    if target_pos.x > position.x:
        sprite_body.scale.x = abs(sprite_body.scale.x)
        sprite_shadow.scale.x = abs(sprite_shadow.scale.x)
        return true
    if target_pos.x < position.x:
        sprite_body.scale.x = -abs(sprite_body.scale.x)
        sprite_shadow.scale.x = -abs(sprite_shadow.scale.x)
        return true
    return false


func adjust_animation_direction_from_cell(target_cell: Vector2i) -> bool:
    if target_cell.x > cell.x:
        sprite_body.scale.x = abs(sprite_body.scale.x)
        sprite_shadow.scale.x = abs(sprite_shadow.scale.x)
        return true
    if target_cell.x < cell.x:
        sprite_body.scale.x = -abs(sprite_body.scale.x)
        sprite_shadow.scale.x = -abs(sprite_shadow.scale.x)
        return true
    return false


func play_animation(animation: String) -> void:
    anim_player.play(animation)
    return
