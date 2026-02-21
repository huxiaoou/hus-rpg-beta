extends Area2D

class_name HurtBox

signal damage_taken(damage: DataDamage, taker: Unit)

@export var size: Vector2 = Vector2(90, 180)
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var owner_unit: Unit = null


func _ready() -> void:
    monitorable = false
    if collision_shape_2d.shape is RectangleShape2D:
        collision_shape_2d.shape.size = size


func setup(unit: Unit) -> void:
    owner_unit = unit
    damage_taken.connect(owner_unit.on_hurt)
    return


func emit_damage_taken(damage: DataDamage) -> void:
    damage_taken.emit(damage, owner_unit)
    return
