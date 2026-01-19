extends Control

class_name UILevel

@onready var label: Label = $Label
@onready var exp_circle: TextureProgressBar = $ExpCircle

var level: int = 1


func _ready() -> void:
    label.text = str(level)


func on_level_changed(new_level: int):
    level = new_level
    label.text = str(level)


func on_exp_changed(new_exp: float):
    var tween: Tween = create_tween()
    tween.tween_property(exp_circle, "value", new_exp, 0.5)
    await tween.finished
    return


func on_level_up(new_level: int, experiences: float, exp_min: float, exp_max: float) -> void:
    on_level_changed(new_level)
    if experiences > exp_circle.max_value: # almost for sure
        on_exp_changed(exp_circle.max_value)
    exp_circle.min_value = exp_min
    exp_circle.max_value = exp_max
    exp_circle.value = exp_min
    on_exp_changed(experiences)
    return
