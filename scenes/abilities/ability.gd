extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

var owner_unit: Unit = null
var is_active: bool = false
var is_casting: bool = false

var max_num_target_cells: int = 16
var max_num_target_units: int = 16
var target_cells: Array[Vector2i] = []
var target_units: Array[Unit] = []

signal selected()
signal canceled()
signal warning()
signal deactivated()


func setup(_owner_unit: Unit, _connect: Callable) -> void:
    owner_unit = _owner_unit
    is_active = false
    is_casting = false
    _connect.call(self)
    return


func activate() -> void:
    is_active = true
    selected.emit()
    print("%s activates Ability %s " % [owner_unit.name, short_name])
    return


func deactivate() -> void:
    is_active = false
    canceled.emit()
    print("%s deactivate ability %s" % [owner_unit.name, short_name])
    return


func launch() -> bool:
    if is_casting:
        warning.emit()
        print("%s is casting ability %s" % [owner_unit.name, short_name])
        return false
    print("%s launches ability %s" % [owner_unit.name, short_name])
    return true


func finish() -> void:
    target_cells.clear()
    target_units.clear()
    is_casting = false
    return


func is_valid(_cell: Vector2i) -> bool:
    return true


func _unhandled_input(event: InputEvent) -> void:
    if not is_active:
        return
    if event.is_action_pressed("left_mouse_click"):
        if target_cells.size() < max_num_target_cells:
            var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
            if is_valid(target_cell):
                target_cells.append(target_cell)
                ManagerCellBattle.set_cell_target(target_cell)
                selected.emit()
                print("Cell %s is add to target cells" % target_cell)
            else:
                warning.emit()
                print("Cell %s is invaild" % target_cell)
        else: # target_cells.size() >= max_num_target_cells:
            launch()
    elif event.is_action_pressed("right_mouse_click"):
        if target_cells.size() > 0:
            if is_casting:
                warning.emit()
                print("Ability %s is casting, can not cancel target" % short_name)
            else:
                var target_cell: Vector2i = target_cells.pop_back()
                ManagerCellBattle.set_cell_vanilla(target_cell)
                canceled.emit()
                print("Cell %s is dropped out from target cells" % target_cell)
        else: # target_cells.size() == 0
            deactivate()
            canceled.emit()
            deactivated.emit()
    return
