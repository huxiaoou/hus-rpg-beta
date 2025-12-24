extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

var owner_unit: Unit = null
var is_casting: bool = false


func setup(_owner_unit: Unit) -> void:
    owner_unit = _owner_unit
    is_casting = false


func start(_start_cell: Vector2i, _end_cell: Vector2i) -> void:
    print("Ability %s starts." % short_name)
    return
