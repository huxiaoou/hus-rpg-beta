extends Area2D

class_name HixBox

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var radius: float = 30
@export var damage: float = 10


func _ready() -> void:
    monitoring = false
    if collision_shape_2d.shape is CircleShape2D:
        collision_shape_2d.shape.radius = radius


func setup(unit: Unit) -> void:
    damage = unit.attack


func _on_area_entered(area: Area2D):
    if area.has_method("take_damage"):
        area.take_damage(damage)
