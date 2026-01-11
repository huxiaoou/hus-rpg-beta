extends Node2D

class_name Unit

signal unit_turn_finished(unit: Unit)
signal unit_attack_impacted(unit: Unit)

enum GroupFlag {
    ALLY,
    ENEMY,
    NEUTRAL,
}

@export_group("Attributes")
@export var initiative: int = 12
@export var group_flag: GroupFlag = GroupFlag.NEUTRAL
@export var health: int = 100
@export var stamina: int = 12
@export var magicka: int = 100
@export var resolve: int = 100
@export var armor: int = 8
@export var attack: int = 12

@export_group("Init")
@export var init_cell: Vector2i

@onready var sprite_body: AnimatedSprite2D = $CharacterBody2D/SpriteBody
@onready var sprite_shadow: AnimatedSprite2D = $CharacterBody2D/SpriteShadow
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
    play_animation("idle")
    return


func setup_in_battle() -> void:
    cell = init_cell
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
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("ability_2"):
        if mgr_abilities.is_active:
            mgr_abilities.show_active_ability()
            return
        mgr_abilities.activiate_ability("ability_sword")
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("EndTurn"):
        if mgr_abilities.is_active:
            mgr_abilities.show_active_ability()
            return
        unit_turn_finished.emit(self)
        get_viewport().set_input_as_handled()
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


func emit_unit_attack_impacted() -> void:
    unit_attack_impacted.emit(self)
    return


func on_hurt(_unit: Unit) -> void:
    anim_player.play("hurt")
    await anim_player.animation_finished
    anim_player.play("idle")
    return


func change_health(delta_health: int) -> void:
    health += delta_health


func change_stamina(delta_stamina: int) -> void:
    stamina += delta_stamina


func change_magicka(delta_magicka: int) -> void:
    magicka += delta_magicka


func change_resolve(delta_resolve: int) -> void:
    resolve += delta_resolve
