extends Node2D

class_name Projectile

@export var speed: float = 1800.0
@export var animation_name: String = "arrow"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hit_box: HitBox = $HitBox
@onready var hit_effect: HitEffect = $HitEffectBlood01

signal impacted()

var p0: Vector2 # Start
var p1: Vector2 # Control
var p2: Vector2 # End
var curve_scale: float = 0.0


func _ready() -> void:
    animated_sprite_2d.animation = animation_name


func on_impacted(_damage: DataDamage, taker: Unit) -> void:
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.3)

    hit_effect.set_location(taker.global_position)
    audio_stream_player_2d.play()
    await hit_effect.play()
    impacted.emit()
    return


func launch(_caster: Unit, target: Unit, _curve_scale: float) -> void:
    print("Launching projectile towards %s" % target.name)
    target.activate_hurt_box()
    self.activate_hit_box()
    target.hurt_box.damage_taken.connect(on_impacted)
    hit_box.setup_from_other(_caster.hit_box)

    curve_scale = _curve_scale
    global_position = _caster.global_position
    p0 = global_position
    p2 = target.global_position
    p1 = Utils.cal_control_point_for_bezier(p0, p2, curve_scale)
    var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_method(_update_position, 0.0, 1.0, (p0.distance_to(p1) + p1.distance_to(p2)) / speed)
    await impacted
    self.deactivate_hit_box()
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
