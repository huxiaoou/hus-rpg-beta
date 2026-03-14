extends CenterContainer

class_name UIInventorySlot

@onready var icon: TextureRect = $Icon
var item: EquipableItem = null


func display_item(_item: EquipableItem):
    item = _item
    if item:
        icon.texture = item.icon
        icon.visible = true
        tooltip_text = item.name + "\nPower: " + str(item.power_bonus)
    else:
        icon.texture = null
        icon.visible = false
        tooltip_text = "Empty Slot"
    return


func _on_gui_input(event: InputEvent) -> void:
    if event.is_action_pressed("equip_item"):
        var unit: Unit = ManagerTurnsAndRounds.active_unit
        if unit != null and item != null:
            var unequipped_item: EquipableItem = unit.manager_equipment.equip(item)
            if unequipped_item:
                ManagerInventory.add_item(unequipped_item)
            ManagerInventory.remove_item(item)
    return
