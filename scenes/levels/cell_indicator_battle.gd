extends Node2D

class_name CellIndicatorBattle

var indicator_cell: Vector2i = Vector2i.ZERO
var toggle_test: bool = false


func _process(_delta: float) -> void:
    var new_mouse_cell: Vector2i = ManagerCellBattle.get_mouse_cell()
    if new_mouse_cell == indicator_cell:
        return
    if !ManagerCellBattle.cell_is_walkable(new_mouse_cell):
        return
    indicator_cell = new_mouse_cell
    position = ManagerCellBattle.cell_to_point(indicator_cell)
    if toggle_test:
        print("Enter Cell %s" % indicator_cell)
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_test"):
        toggle_test = !toggle_test
        print("toggle_test: %s" % toggle_test)
    return
