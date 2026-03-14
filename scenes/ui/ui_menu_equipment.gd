extends Control

class_name UIMenuEquipment

@onready var slot_weapon: UIEquipmentSlot = $Body/SlotWeapon
@onready var slot_armor: UIEquipmentSlot = $Body/SlotArmor
@onready var slot_accessory: UIEquipmentSlot = $Body/SlotAccessory

var unit: Unit


func _ready():
    hide()
    process_mode = Node.PROCESS_MODE_ALWAYS
    ManagerTurnsAndRounds.active_unit_changed.connect(on_active_unit_changed)
    return


func on_active_unit_changed(_unit: Unit) -> void:
    if unit:
        unit.manager_equipment.equipment_changed.disconnect(refresh_ui)
    unit = _unit
    if unit:
        unit.manager_equipment.equipment_changed.connect(refresh_ui)
        refresh_ui()
    return


func refresh_ui() -> void:
    var gear = unit.manager_equipment.equipped_items
    slot_weapon.display_item(gear.get(EquipableItem.TypeSlot.WEAPON))
    slot_armor.display_item(gear.get(EquipableItem.TypeSlot.ARMOR))
    slot_accessory.display_item(gear.get(EquipableItem.TypeSlot.ACCESSORY))
    return


func _input(event: InputEvent) -> void:
    if not unit:
        return
    if unit.is_ai():
        return
    if event.is_action_pressed("toggle_invetory"):
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
