extends Control

class_name UILevel

@onready var label: Label = $Label
@onready var exp_circle: TextureProgressBar = $ExpCircle

var level: int = 1
var experiences: int = 0


func _ready() -> void:
    label.text = str(level)


func on_level_changed(new_level: int):
    level = new_level
    label.text = str(level)

func on_exp_changed(new_exp: int):
    experiences = new_exp
    exp_circle.value = experiences
    return
