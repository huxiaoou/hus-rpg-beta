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
var target_cell: Vector2i:
    get:
        return Vector2i.ZERO if target_cells.is_empty() else target_cells[0]
var target_units: Array[Unit] = []
var target_unit: Unit:
    get:
        return null if target_units.is_empty() else target_units[0]

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
    is_casting = true
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
            var new_target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
            if is_valid(new_target_cell):
                target_cells.append(new_target_cell)
                ManagerCellBattle.set_cell_target(new_target_cell)
                selected.emit()
                print("Cell %s is add to target cells" % new_target_cell)
            else:
                warning.emit()
                print("Cell %s is invaild" % new_target_cell)
        else: # target_cells.size() >= max_num_target_cells:
            launch()
    elif event.is_action_pressed("right_mouse_click"):
        if target_cells.size() > 0:
            if is_casting:
                warning.emit()
                print("Ability %s is casting, can not cancel target" % short_name)
            else:
                var old_target_cell: Vector2i = target_cells.pop_back()
                ManagerCellBattle.set_cell_vanilla(old_target_cell)
                canceled.emit()
                print("Cell %s is dropped out from target cells" % old_target_cell)
        else: # target_cells.size() == 0
            deactivate()
            canceled.emit()
            deactivated.emit()
    return
