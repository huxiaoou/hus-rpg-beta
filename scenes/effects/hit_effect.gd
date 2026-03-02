extends Node2D

class_name HitEffect

@export_group("Visual_Effects")
@export var rotation_range: Vector2 = Vector2.ZERO
@export var display_scale: Vector2 = Vector2(0.5, 0.5)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
    scale = display_scale
    visible = false


func play_effect() -> void:
    animated_sprite_2d.play(animated_sprite_2d.animation)
    return


func play_main() -> void:
    rotation = randf_range(rotation_range.x, rotation_range.y)
    visible = true
    animation_player.play("main")
    await animation_player.animation_finished
    visible = false
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("test_add"):
        play_main()
