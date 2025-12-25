extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

var owner_unit: Unit = null
var is_active: bool = false
var is_casting: bool = false
var deactivate: Callable

var max_num_target_cells: int = 16
var max_num_target_units: int = 16
var target_cells: Array[Vector2i] = []
var target_units: Array[Unit] = []


func setup(_owner_unit: Unit, _deactivate: Callable) -> void:
    owner_unit = _owner_unit
    deactivate = _deactivate
    is_casting = false
    return


func finish() -> void:
    target_cells.clear()
    target_units.clear()
    is_casting = false
    return


func launch() -> void:
    print("Ability %s launches." % short_name)
    return


func _unhandled_input(event: InputEvent) -> void:
    if not is_active:
        return
    if event.is_action_pressed("left_mouse_click"):
        if target_cells.size() < max_num_target_cells:
            var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
            target_cells.append(target_cell)
            ManagerCellBattle.set_cell_red(target_cell)
            print("%s is add to target cells" % target_cell)
        else:
            launch()
    elif event.is_action_pressed("right_mouse_click"):
        if target_cells.size() > 0:
            if is_casting:
                print("Ability %s is casing, can not cancel target" % short_name)
            else:
                var target_cell: Vector2i = target_cells.pop_back()
                ManagerCellBattle.set_cell_white(target_cell)
                print("%s is canceled" % target_cell)
        else: # target_cells.size() == 0
            deactivate.call()
    return
