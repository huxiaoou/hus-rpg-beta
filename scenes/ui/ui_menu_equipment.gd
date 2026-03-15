extends Control

class_name UIMenuEquipment

@onready var inventory: UIInventory = $Inventory

func _ready():
    hide()
    process_mode = Node.PROCESS_MODE_ALWAYS
    return


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_invetory"):
        if ManagerTurnsAndRounds.active_unit == null:
            return
        if ManagerTurnsAndRounds.active_unit.is_ai():
            return
        toggle_menu()


func toggle_menu():
    visible = not visible
    return

    # var new_pause_state: bool = !get_tree().paused
    # get_tree().paused = new_pause_state
    # if new_pause_state:
    #     show()
    # else:
    #     hide()


func _on_unit_equipment_unit_set(unit: Unit) -> void:
    inventory.set_unit(unit)
    return
