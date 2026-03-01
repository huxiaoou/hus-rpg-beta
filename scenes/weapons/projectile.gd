extends Node2D

class_name Projectile

@export var speed: float = 1800.0
@export var scene_hit_effect: PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit_box: HitBox = $HitBox

signal impacted()

var p0: Vector2 # Start
var p1: Vector2 # Control
var p2: Vector2 # End
var curve_scale: float = 0.0
var target_cell: Vector2i


func on_unit_damage_taken(_damage: DataDamage, taker: Unit) -> void:
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.3)

    var hit_effect: HitEffect = scene_hit_effect.instantiate()
    taker.add_child(hit_effect)
    hit_effect.global_position = ManagerCellBattle.cell_to_point(taker.cell)
    audio_stream_player_2d.play()
    await hit_effect.play_main()
    hit_effect.queue_free()
    impacted.emit()
    return


func launch(_caster: Unit, _target_cell: Vector2i, targets: Array[Unit], _curve_scale: float) -> void:
    target_cell = _target_cell
    print("Launching projectile %s towards %s" % [name, target_cell])
    self.activate_hit_box()
    hit_box.setup_from_other(_caster.hit_box)
    for target: Unit in targets:
        target.activate_hurt_box()
        target.hurt_box.damage_taken.connect(on_unit_damage_taken)
        print("%s is targeted by projectile" % target.data.name)
    curve_scale = _curve_scale
    global_position = _caster.global_position
    p0 = global_position
    p2 = ManagerCellBattle.cell_to_point(_target_cell)
    p1 = Utils.cal_control_point_for_bezier(p0, p2, curve_scale)
    var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_method(_update_position, 0.0, 1.0, (p0.distance_to(p1) + p1.distance_to(p2)) / speed)

    for target in targets:
        await impacted
    self.deactivate_hit_box()
    for target in targets:
        target.deactivate_hurt_box()
    queue_free()
    return


func _update_position(t: float):
    var q0: Vector2 = p0.lerp(p1, t)
    var q1: Vector2 = p1.lerp(p2, t)
    global_position = q0.lerp(q1, t)
    look_at(p2)
    return


func activate_hit_box() -> void:
    hit_box.monitoring = true
    return


func deactivate_hit_box() -> void:
    hit_box.monitoring = false
    return
