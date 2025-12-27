extends Node2D

class_name Unit

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


func _ready() -> void:
    mgr_abilities.setup(self)
    setup_astreams()
    play_animation("idle")
    return


func setup_astreams() -> void:
    astreams["walk"] = astream_walk
    return

func setup_in_battle()->void:
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
    if event.is_action_pressed("ability_1"):
        mgr_abilities.activiate_ability("ability_move")
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


func play_animation(animation: String) -> void:
    anim_player.play(animation)
    return
