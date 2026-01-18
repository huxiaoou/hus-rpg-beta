extends Control

class_name UIEnergyPoint

@export_group("Custom")
@export var max_value: float = 2.0
@export var min_value: float = 0.0
@export var step: float = 0.05

@onready var progress_point: TextureProgressBar = $ProgressPoint


func _ready() -> void:
    setup()
    return


func setup() -> void:
    progress_point.value = max_value
    progress_point.max_value = max_value
    progress_point.min_value = min_value
    progress_point.step = step
    return


func set_value(value: float) -> void:
    var tw: Tween = create_tween()
    tw.tween_property(progress_point, "value", clamp(value, min_value, max_value), 0.5)
    return
