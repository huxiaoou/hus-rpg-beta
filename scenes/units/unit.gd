extends Node2D

class_name Unit

@export_group("Audios")
@export var stream_walk: AudioStream

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $CharacterBody2D/AudioStreamPlayer2D
@onready var ability_move: AbilityMove = $AbilityMove
@onready var animation_player: AnimationPlayer = $CharacterBody2D/AnimationPlayer

var astreams: Dictionary[String, AudioStream] = {}


func _ready() -> void:
    ability_move.unit_owner = self
    astreams["walk"] = stream_walk
    play_animation("idle")
    return


func load_audio_stream(astream_name: String) -> void:
    var astream_to_load: AudioStream = astreams[astream_name]
    if audio_stream_player_2d.stream != astream_to_load:
        audio_stream_player_2d.stop()
        audio_stream_player_2d.stream = astream_to_load
        return


func move_toward(target_pos: Vector2, distance: float) -> void:
    position = position.move_toward(target_pos, distance)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("left_mouse_click"):
        var start_cell: Vector2i = ManagerCellBattle.point_to_cell(position)
        var end_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
        ability_move.start(start_cell, end_cell)
    return


func adjust_animation_direction(target_pos: Vector2) -> bool:
    if target_pos.x > position.x:
        animated_sprite_2d.scale.x = abs(animated_sprite_2d.scale.x)
        return true
    if target_pos.x < position.x:
        animated_sprite_2d.scale.x = -abs(animated_sprite_2d.scale.x)
        return true
    return false


func play_animation(animation: String) -> void:
    animation_player.play(animation)
    return
