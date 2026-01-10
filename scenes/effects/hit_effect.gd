extends Node2D

class_name HitEffect

@export_group("Resources")
@export var display_scale: Vector2 = Vector2.ONE
@export var sprt_frms: Texture2D
@export var vframes: int = 1
@export var frm_duration_seconds: float = 0.04
@export var sound_effect: AudioStream
const SPRT_TRACK: int = 0

@export_group("Visual_Effects")
@export var pos_offset: Vector2 = Vector2(0, -32)
@export var rotation_rng: Vector2 = Vector2.ZERO
@export var animation_modulate: Color = Color.WHITE

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
    scale = display_scale
    sprite_2d.texture = sprt_frms
    sprite_2d.hframes = 1
    sprite_2d.vframes = vframes
    sprite_2d.modulate = animation_modulate
    audio_stream_player_2d.stream = sound_effect
    var main_anim: Animation = animation_player.get_animation("main")
    main_anim.length = frm_duration_seconds * vframes
    for i: int in range(vframes):
        main_anim.track_insert_key(SPRT_TRACK, frm_duration_seconds * i, i)
    return


func set_location(location: Vector2) -> void:
    position = location + pos_offset
    return


func play(_unit: Unit) -> void:
    rotation = randf_range(rotation_rng.x, rotation_rng.y)
    visible = true
    animation_player.play("main")
    await animation_player.animation_finished
    visible = false
    return
