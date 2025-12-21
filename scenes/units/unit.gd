extends Node2D

class_name Unit

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var ability_move: AbilityMove = $AbilityMove


func _ready() -> void:
    setup()
    return


func setup() -> void:
    ability_move.unit_owner = self


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
