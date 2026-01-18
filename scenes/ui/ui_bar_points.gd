extends HBoxContainer

class_name UIEnergyPoints

@export var tot_size: int = 6
@export var point_max_val: float = 2.0

var bar_val: float = 0
var bar_max_val: float = 0
var bar_min_val: float = 0
var bar_points: Array[UIEnergyPoint] = []


func _ready() -> void:
    var scene_point: PackedScene = preload("res://scenes/ui/ui_energy_point.tscn")
    for i: int in range(tot_size):
        var point: UIEnergyPoint = scene_point.instantiate()
        add_child(point)
        point.max_value = point_max_val
        point.setup()
        bar_points.append(point)
    bar_max_val = point_max_val * tot_size
    change_bar(bar_max_val)
    return


func update_points() -> void:
    var qty_full_points: int = int(bar_val / point_max_val)
    var remainder_val: int = int(bar_val) % int(point_max_val)
    for i: int in range(tot_size):
        if i < qty_full_points:
            bar_points[i].set_value(point_max_val)
        elif i == qty_full_points:
            bar_points[i].set_value(remainder_val)
        else:
            bar_points[i].set_value(0)
    return


func _change_bar_value(delta: float) -> void:
    bar_val = clampf(bar_val + delta, bar_min_val, bar_max_val)
    return


func _set_bar_value(value: float) -> void:
    bar_val = clampf(value, bar_min_val, bar_max_val)
    return


func change_bar(delta: float) -> void:
    _change_bar_value(delta)
    update_points()
    return


func set_bar(value: float) -> void:
    _set_bar_value(value)
    update_points()
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("test_add"):
        change_bar(1.0)
    elif event.is_action_pressed("test_subtract"):
        change_bar(-1.0)
    return
