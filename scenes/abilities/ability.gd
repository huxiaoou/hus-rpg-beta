extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

var owner_unit: Unit = null
var is_active: bool = false
var is_casting: bool = false
var deactivate_callback: Callable

var max_num_target_cells: int = 16
var max_num_target_units: int = 16
var target_cells: Array[Vector2i] = []
var target_units: Array[Unit] = []

signal selected()
signal canceled()
signal warning()


func setup(_owner_unit: Unit, _deactivate_callback: Callable) -> void:
    owner_unit = _owner_unit
    deactivate_callback = _deactivate_callback
    is_casting = false
    return


func activate() -> void:
    is_active = true
    selected.emit()
    print("Ability %s is activated" % short_name)
    return


func deactivate() -> void:
    is_active = false
    canceled.emit()
    print("Deactivate ability %s" % short_name)
    return


func launch() -> bool:
    if is_casting:
        warning.emit()
        print("Ability %s is casting" % short_name)
        return false
    print("Ability %s launches." % short_name)
    return true


func finish() -> void:
    target_cells.clear()
    target_units.clear()
    is_casting = false
    return


func _unhandled_input(event: InputEvent) -> void:
    if not is_active:
        return
    if event.is_action_pressed("left_mouse_click"):
        if target_cells.size() < max_num_target_cells:
            var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
            target_cells.append(target_cell)
            ManagerCellBattle.set_cell_red(target_cell)
            selected.emit()
            print("%s is add to target cells" % target_cell)
        else:
            launch()
    elif event.is_action_pressed("right_mouse_click"):
        if target_cells.size() > 0:
            if is_casting:
                warning.emit()
                print("Ability %s is casting, can not cancel target" % short_name)
            else:
                var target_cell: Vector2i = target_cells.pop_back()
                ManagerCellBattle.set_cell_white(target_cell)
                canceled.emit()
                print("%s is canceled" % target_cell)
        else: # target_cells.size() == 0
            canceled.emit()
            deactivate_callback.call()
    return
