extends Node2D

class_name Unit

signal unit_turn_finished(unit: Unit)
signal melee_weapon_impacted()
signal ranged_projectile_launched()
signal get_hurt()
signal died(unit: Unit)

@export_group("Data")
@export var data: DataUnit

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var sprite_body: AnimatedSprite2D = $CharacterBody2D/SpriteBody
@onready var sprite_shadow: AnimatedSprite2D = $CharacterBody2D/SpriteShadow
@onready var anim_player: AnimationPlayer = $CharacterBody2D/AnimPlayer
@onready var mgr_abilities: ManagerAbilities = $ManagerAbilities
@onready var ui_floating_health_bar: UIFloatingHealthBar = $UIFloatingHealthBar
@onready var hurt_box: HurtBox = $CharacterBody2D/HurtBox
@onready var hit_box: HitBox = $CharacterBody2D/HitBox
@onready var manager_equipment: ManagerEquipment = $ManagerEquipment

var astreams: Dictionary[String, AudioStream] = { }
var cell: Vector2i:
    get:
        return ManagerCellBattle.point_to_cell(position)
    set(value):
        data.cell = value
        position = ManagerCellBattle.cell_to_point(value)
        ManagerCellBattle.disable_cell(value, self)


static func sort_by_initiative(a: Unit, b: Unit) -> bool:
    return a.data.has_greater_turn_order(b.data)


func _ready() -> void:
    play_animation("idle")
    ui_floating_health_bar.init_from_unit(self)
    hurt_box.setup(self)
    manager_equipment.equipment_changed.connect(on_equipped_item_changed)
    ManagerTurnsAndRounds.active_unit_changed.connect(on_turn_begin)
    cell = data.cell
    return


func is_ai() -> bool:
    return data.is_ai


func is_ally() -> bool:
    return data.group_flag == DataUnit.GroupFlag.ALLY


func is_enemy() -> bool:
    return data.group_flag == DataUnit.GroupFlag.ENEMY


func is_neutral() -> bool:
    return data.group_flag == DataUnit.GroupFlag.NEUTRAL


func move_toward(target_pos: Vector2, distance: float) -> void:
    position = position.move_toward(target_pos, distance)
    return


func on_turn_begin(unit: Unit) -> void:
    if unit != self:
        return
    data.regen()
    if is_ai():
        for i: int in range(3, 0, -1):
            print("%s is thinking ... %d" % [data.name, i])
            await get_tree().create_timer(0.5).timeout
        try_ai_to_cast()
    return


func try_ai_to_cast() -> void:
    while true:
        var ability: Ability = mgr_abilities.find_best_ability_to_cast()
        if ability.score_gt_zero():
            ability.call_ai_to_cast()
            await ability.deactivated
        else:
            break
    print("%s has no good ability to cast, ending turn" % data.name)
    unit_turn_finished.emit(self)
    return


func _unhandled_input(event: InputEvent) -> void:
    if not ManagerTurnsAndRounds.is_active(self):
        return
    if is_ai():
        return
    if event.is_action_pressed("EndTurn"):
        if mgr_abilities.has_selected_ability:
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


func emit_melee_weapon_impacted() -> void:
    melee_weapon_impacted.emit()
    return


func emit_ranged_projectile_launched() -> void:
    ranged_projectile_launched.emit()
    return


func cal_net_damage(damage: DataDamage) -> int:
    return int(damage.amount * (1 - min((get_final_armor() as float) / 40, 1)))


func on_hurt(damage: DataDamage, _taker: Unit) -> void:
    var net_dmg: int = cal_net_damage(damage)
    data.change_health(-net_dmg)
    anim_player.play("hurt")
    print("%s attacks with attack %d" % [damage.caster.data.name, damage.amount])
    print("%s takes %d damage, health is %d" % [data.name, net_dmg, data.health])
    await anim_player.animation_finished
    get_hurt.emit()
    if data.health <= 0:
        anim_player.play("die")
        await anim_player.animation_finished
        if ManagerTurnsAndRounds.is_active(self):
            unit_turn_finished.emit(self)
        died.emit(self)
    else:
        anim_player.play("idle")
    return


func on_equipped_item_changed() -> void:
    update_hit_box()
    return


func get_final_attack() -> int:
    return data.attack + manager_equipment.get_power_bonus()


func get_final_armor() -> int:
    return data.armor + manager_equipment.get_defense_bonus()


func update_hit_box() -> void:
    hit_box.damage.caster = self
    hit_box.damage.amount = get_final_attack()
    hit_box.damage.dmg_type = DataDamage.EDmgType.PHYSICS
    return


func activate_hit_box() -> void:
    hit_box.monitoring = true
    return


func deactivate_hit_box() -> void:
    hit_box.monitoring = false
    return


func activate_hurt_box() -> void:
    hurt_box.monitorable = true
    return


func deactivate_hurt_box() -> void:
    hurt_box.monitorable = false
    return


func clear() -> void:
    ManagerCellBattle.set_cell_vanilla(cell)
    ManagerCellBattle.enable_cell(cell)
    queue_free()
    return
