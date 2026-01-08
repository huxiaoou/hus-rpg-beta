extends Node2D

class_name HitEffect

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_pos(pos: Vector2, shift: Vector2 = Vector2(0, -40)) -> void:
    position = pos + shift
    rotation = randf_range(0, TAU)
    return


func play(_unit: Unit) -> void:
    visible = true
    animation_player.play("main")
    await animation_player.animation_finished
    visible = false
    return
