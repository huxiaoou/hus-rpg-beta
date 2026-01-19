extends HBoxContainer

class_name UIEnergyPoints

@export var tot_size: int = 6
@export var point_max_val: float = 2.0

var bar_val: float = 0
var bar_max_val: float = 0
var bar_min_val: float = 0
var bar_points: Array[UIEnergyPoint] = []


func _ready() -> void:
    var counter: int = 0
    for point: UIEnergyPoint in get_children():
        bar_points.append(point)
        counter += 1

    if counter <= tot_size:
        var scene_point: PackedScene = preload("res://scenes/ui/ui_energy_point.tscn")
        for i: int in range(tot_size - counter):
            var point: UIEnergyPoint = scene_point.instantiate()
            add_child(point)
            bar_points.append(point)
    else:
        for i: int in range(counter - tot_size):
            var point: UIEnergyPoint = bar_points.pop_back()
            point.queue_free()

    for point: UIEnergyPoint in bar_points:
        point.max_value = point_max_val
        point.setup()
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


func on_bar_changed(value: float) -> void:
    _set_bar_value(value)
    update_points()
    return
