extends Area2D

class_name HitBox

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var radius: float = 30
@export var damage: DataDamage = DataDamage.new()


func _ready() -> void:
    monitoring = false
    if collision_shape_2d.shape is CircleShape2D:
        collision_shape_2d.shape.radius = radius


func setup(unit: Unit, amount: float, dmg_type: DataDamage.EDmgType) -> void:
    damage.caster = unit
    damage.amount = amount
    damage.dmg_type = dmg_type
    return


func _on_area_entered(area: Area2D):
    if area is HurtBox:
        area.emit_damage_taken(damage)
    return
