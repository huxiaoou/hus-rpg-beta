extends Node2D

class_name Unit

signal unit_turn_finished(unit: Unit)
signal unit_melee_weapon_impacted(unit: Unit)

@export_group("Data")
@export var data_unit: DataUnit

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var sprite_body: AnimatedSprite2D = $CharacterBody2D/SpriteBody
@onready var sprite_shadow: AnimatedSprite2D = $CharacterBody2D/SpriteShadow
@onready var anim_player: AnimationPlayer = $CharacterBody2D/AnimPlayer
@onready var mgr_abilities: ManagerAbilities = $ManagerAbilities
@onready var ui_floating_health_bar: UIFloatingHealthBar = $UIFloatingHealthBar
@onready var hurt_box: HurtBox = $CharacterBody2D/HurtBox
@onready var hit_box: HitBox = $CharacterBody2D/HitBox

var astreams: Dictionary[String, AudioStream] = { }
var cell: Vector2i:
    get:
        return ManagerCellBattle.point_to_cell(position)
    set(value):
        position = ManagerCellBattle.cell_to_point(value)


static func sort_by_initiative(a: Unit, b: Unit) -> bool:
    return a.data_unit.has_greater_turn_order(b.data_unit)


func _ready() -> void:
    #ui_floating_health_bar.init_fr
    mgr_abilities.setup()
    play_animation("idle")
    hurt_box.owner_unit = self
    return


func setup_in_battle() -> void:
    cell = data_unit.init_cell
    return


func is_ally() -> bool:
    return data_unit.group_flag == DataUnit.GroupFlag.ALLY


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
    elif event.is_action_pressed("ability_3"):
        if mgr_abilities.is_active:
            mgr_abilities.show_active_ability()
            return
        mgr_abilities.activiate_ability("ability_projectile")
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
        # sprite_body.scale.x = abs(sprite_body.scale.x)
        # sprite_shadow.scale.x = abs(sprite_shadow.scale.x)
        scale.x = abs(scale.x)
        return true
    if target_pos.x < position.x:
        # sprite_body.scale.x = -abs(sprite_body.scale.x)
        # sprite_shadow.scale.x = -abs(sprite_shadow.scale.x)
        scale.x = -abs(scale.x)
        return true
    return false


func adjust_animation_direction_from_cell(target_cell: Vector2i) -> bool:
    if target_cell.x > cell.x:
        # sprite_body.scale.x = abs(sprite_body.scale.x)
        # sprite_shadow.scale.x = abs(sprite_shadow.scale.x)
        scale.x = abs(scale.x)
        return true
    if target_cell.x < cell.x:
        # sprite_body.scale.x = -abs(sprite_body.scale.x)
        # sprite_shadow.scale.x = -abs(sprite_shadow.scale.x)
        scale.x = -abs(scale.x)
        return true
    return false


func play_animation(animation: String) -> void:
    anim_player.play(animation)
    return


func emit_unit_melee_weapon_impacted() -> void:
    unit_melee_weapon_impacted.emit(self)
    return


func cal_damage(data_damage: DataDamage) -> int:
    return int(data_damage.amount * (1 - min((data_unit.armor as float) / 40, 1)))


func on_hurt(data_damage: DataDamage) -> void:
    var damage: int = cal_damage(data_damage)
    data_unit.change_health(-damage)
    anim_player.play("hurt")
    print("%s attacks with attack %d" % [data_damage.caster, data_damage.amount])
    print("%s takes %d damage, health is %d" % [name, damage, data_unit.health])
    await anim_player.animation_finished
    if data_unit.health <= 0:
        anim_player.play("die")
    else:
        anim_player.play("idle")
    return


func update_hit_box() -> void:
    hit_box.damage.caster = self
    hit_box.damage.amount = data_unit.attack
    hit_box.damage.dmg_type = DataDamage.EDmgType.PHYSICS
    return
