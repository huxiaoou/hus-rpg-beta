extends Node2D

class_name Projectile

signal impacted()

@export var speed: float = 600.0

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var caster: Node2D = null
var p0: Vector2 # Start
var p1: Vector2 # Control
var p2: Vector2 # End
var curve_scale: float = 0.0


func _ready() -> void:
    impacted.connect(on_impacted)


func on_impacted(_unit: Unit) -> void:
    audio_stream_player_2d.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body == caster:
        print("Ignored collision with caster %s" % caster.get_parent().name)
        return
    print("Body entered: %s" % body.name)
    impacted.emit(body.get_parent())


func launch(_caster: Unit, target: Unit, _curve_scale: float) -> void:
    print("Launching projectile towards %s" % target.name)
    caster = _caster.character_body_2d
    curve_scale = _curve_scale
    global_position = _caster.global_position
    p0 = global_position
    p2 = target.global_position
    p1 = Utils.cal_control_point_for_bezier(p0, p2, curve_scale)
    var tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_method(_update_position, 0.0, 1.0, (p0.distance_to(p1) + p1.distance_to(p2)) / speed)
    await tw.finished
    queue_free()
    return


func _update_position(t: float):
    var q0: Vector2 = p0.lerp(p1, t)
    var q1: Vector2 = p1.lerp(p2, t)
    global_position = q0.lerp(q1, t)
    look_at(p2)
    return
