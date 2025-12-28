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

var states_book: Dictionary[String, AbilityState] = { }
var cur_state: AbilityState = null

signal selected()
signal canceled()
signal warning()

@onready var states: Node = $States


func setup(_owner_unit: Unit, _deactivate_callback: Callable, _connect: Callable) -> void:
    owner_unit = _owner_unit
    deactivate_callback = _deactivate_callback
    is_casting = false
    _connect.call(self)
    for state: AbilityState in states.get_children():
        state.setup(self)
        states_book[state.name] = state
    cur_state = states_book.get("Deactive")
    cur_state.enter()
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


func change_state(new_state_name: String) -> void:
    var new_state: AbilityState = states_book.get(new_state_name)
    if new_state == null:
        return
    cur_state.exit()
    cur_state = new_state
    cur_state.enter()
    return


func _process(delta: float) -> void:
    cur_state.process(delta)
    return


func warning_is_casting() -> void:
    warning.emit()
    print("%s is casting ability" % [owner_unit.name, short_name])
    return


func launch() -> void:
    is_casting = true
    print("%s launches ability %s." % [owner_unit.name, short_name])
    return


func finish() -> void:
    target_cells.clear()
    target_units.clear()
    is_casting = false
    return


func targets_are_full() -> bool:
    return target_cells.size() >= max_num_target_cells


func has_targets() -> bool:
    return target_cells.size() > 0


func add_target_cell() -> void:
    var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
    target_cells.append(target_cell)
    ManagerCellBattle.set_cell_red(target_cell)
    selected.emit()
    print("Cell %s is add to target cells" % target_cell)
    return


func drop_target_cell() -> void:
    var target_cell: Vector2i = target_cells.pop_back()
    ManagerCellBattle.set_cell_white(target_cell)
    canceled.emit()
    print("Cell %s is dropped from target cells" % target_cell)
    return

# func _unhandled_input(event: InputEvent) -> void:
#     if not is_active:
#         return
#     if event.is_action_pressed("left_mouse_click"):
#             var target_cell: Vector2i = ManagerCellBattle.get_indicator_cell()
#             target_cells.append(target_cell)
#             ManagerCellBattle.set_cell_red(target_cell)
#             selected.emit()
#             print("Cell %s is add to target cells" % target_cell)
#         else: # target_cells.size() >= max_num_target_cells:
#             launch()
#     elif event.is_action_pressed("right_mouse_click"):
#         if target_cells.size() > 0:
#             if is_casting:
#                 warning.emit()
#                 print("Ability %s is casting, can not cancel target" % short_name)
#             else:
#                 var target_cell: Vector2i = target_cells.pop_back()
#                 ManagerCellBattle.set_cell_white(target_cell)
#                 canceled.emit()
#                 print("Cell %s is dropped out from target cells" % target_cell)
#         else: # target_cells.size() == 0
#             canceled.emit()
#             deactivate_callback.call()
#     return
