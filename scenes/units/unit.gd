extends Node2D

class_name Unit

@export_group("walk")
@export var walk_astream: AudioStream
@export var walk_frames: Array[int]

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $CharacterBody2D/AudioStreamPlayer2D
@onready var ability_move: AbilityMove = $AbilityMove


func _ready() -> void:
    ability_move.unit_owner = self
    animated_sprite_2d.frame_changed.connect(on_frame_changed)
    return


func load_audio_stream(astream_to_load: AudioStream) -> void:
    if audio_stream_player_2d.stream != astream_to_load:
        audio_stream_player_2d.stop()
        audio_stream_player_2d.stream = astream_to_load
        return


func on_frame_changed():
    if animated_sprite_2d.animation == "walk":
        if animated_sprite_2d.frame in walk_frames:
            audio_stream_player_2d.play()


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
    animated_sprite_2d.play(animation)
    return
