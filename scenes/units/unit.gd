extends Node2D

class_name Unit

signal unit_turn_finished(unit: Unit)
signal unit_attack_impacted(unit: Unit)
signal unit_health_changed(health: int)
signal unit_magicka_changed(magicka: int)
signal unit_stamina_changed(stamina: int)
signal unit_resolve_changed(resolve: int)

enum GroupFlag {
    ALLY,
    ENEMY,
    NEUTRAL,
}

@export_group("UI")
@export var avatar: Texture2D

@export_group("Attributes")
@export var group_flag: GroupFlag = GroupFlag.NEUTRAL
@export var health: int = 100
@export var stamina: int = 100
@export var magicka: int = 100
@export var resolve: int = 100
@export var max_health: int = 100
@export var max_stamina: int = 100
@export var max_magicka: int = 100
@export var max_resolve: int = 100
@export var attack: int = 24
@export var armor: int = 8
@export var initiative: int = 12

@export_group("Init")
@export var init_cell: Vector2i

@onready var sprite_body: AnimatedSprite2D = $CharacterBody2D/SpriteBody
@onready var sprite_shadow: AnimatedSprite2D = $CharacterBody2D/SpriteShadow
@onready var anim_player: AnimationPlayer = $CharacterBody2D/AnimPlayer
@onready var mgr_abilities: ManagerAbilities = $ManagerAbilities
@onready var ui_floating_health_bar: UIFloatingHealthBar = $UIFloatingHealthBar

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
    connect_ui_floating_health_bar()
    mgr_abilities.setup(self)
    play_animation("idle")
    return


func connect_ui_avatar(ui_avatar: UIAvatar) -> void:
    ui_avatar.ui_unit_frame.set_avatar(avatar)

    # health bar
    ui_avatar.ui_bar_health.init_value(health, max_health, 0, 1)
    unit_health_changed.connect(ui_avatar.ui_bar_health.on_value_changed)

    # magicka bar
    ui_avatar.ui_bar_magicka.init_value(magicka, max_magicka, 0, 1)
    unit_magicka_changed.connect(ui_avatar.ui_bar_magicka.on_value_changed)

    # stamina bar
    ui_avatar.ui_bar_stamina.init_value(stamina, max_stamina, 0, 1)
    unit_stamina_changed.connect(ui_avatar.ui_bar_stamina.on_value_changed)

    # resolve bar
    ui_avatar.ui_bar_resolve.init_value(resolve, max_resolve, 0, 1)
    unit_resolve_changed.connect(ui_avatar.ui_bar_resolve.on_value_changed)

    ui_avatar.ui_status_attack.set_value(attack)
    ui_avatar.ui_status_armor.set_value(armor)
    ui_avatar.ui_status_initiative.set_value(initiative)
    return


func connect_ui_floating_health_bar() -> void:
    ui_floating_health_bar.init_value(health, max_health, 0, 1)
    unit_health_changed.connect(ui_floating_health_bar.on_value_changed)
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


func on_hurt(unit: Unit) -> void:
    var damage: int = (unit.attack * (1 - min((armor as float) / 40, 1))) as int
    change_health(-damage)
    anim_player.play("hurt")
    print("%s attacks with attack %d" % [unit.name, unit.attack])
    print("%s takes %d damage, health is %d" % [name, damage, health])
    await anim_player.animation_finished
    if health <= 0:
        anim_player.play("die")
    else:
        anim_player.play("idle")
    return


func change_health(delta_health: int) -> void:
    health = clampi(health + delta_health, 0, max_health)
    unit_health_changed.emit(health)
    return


func change_stamina(delta_stamina: int) -> void:
    stamina = clampi(stamina + delta_stamina, 0, max_stamina)
    unit_stamina_changed.emit(stamina)
    return


func change_magicka(delta_magicka: int) -> void:
    magicka = clampi(magicka + delta_magicka, 0, max_magicka)
    unit_magicka_changed.emit(magicka)
    return


func change_resolve(delta_resolve: int) -> void:
    resolve = clampi(resolve + delta_resolve, 0, max_resolve)
    unit_resolve_changed.emit(resolve)
    return
