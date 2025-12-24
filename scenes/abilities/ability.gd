extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

var owner_unit: Unit = null
var is_active: bool = false
var is_casting: bool = false
var cancel_active: Callable

var max_num_target_cells: int = 1
var max_num_target_units: int = 1
var target_cells: Array[Vector2i] = []
var target_units: Array[Unit] = []


func setup(_owner_unit: Unit, _cancel_active: Callable) -> void:
    owner_unit = _owner_unit
    cancel_active = _cancel_active
    is_casting = false


func launch() -> void:
    pass


func start(_start_cell: Vector2i, _end_cell: Vector2i) -> void:
    print("Ability %s starts." % short_name)
    return


func _unhandled_input(event: InputEvent) -> void:
    if not is_active:
        return
    if event.is_action_pressed("left_mouse_click"):
        if target_cells.size() < max_num_target_cells:
            var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
            target_cells.append(target_cell)
            print("%s is add to target cells" % target_cell)
        else:
            launch()
    elif event.is_action_pressed("right_mouse_click"):
        if target_cells.size() > 0:
            print("%s is canceled" % target_cells.pop_back())
        else: # target_cells.size() == 0
            cancel_active.call(null)
    return
