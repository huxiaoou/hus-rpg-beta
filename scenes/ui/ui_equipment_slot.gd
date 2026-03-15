extends CenterContainer

class_name UIEquipmentSlot

@export var slot_type: EquipableItem.TypeSlot
@onready var icon: TextureRect = $Icon

var item: EquipableItem = null
var unit: Unit = null


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
    if event.is_action_pressed("unequip_item"):
        if unit != null and item != null:
            var unequipped_item: EquipableItem = unit.manager_equipment.unequip(item.slot)
            ManagerInventory.add_item(unequipped_item)
    return
