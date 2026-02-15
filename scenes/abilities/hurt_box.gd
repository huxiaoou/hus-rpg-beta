extends Area2D

class_name HurtBox

@export var size: Vector2 = Vector2(90, 180)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var owner_unit: Unit = null


func _ready() -> void:
    if collision_shape_2d.shape is RectangleShape2D:
        collision_shape_2d.shape.size = size


func take_damage(damage: DataDamage) -> void:
    if owner_unit == damage.caster:
        return
    print("%s takes damage: %s" % [owner_unit.name, damage])
