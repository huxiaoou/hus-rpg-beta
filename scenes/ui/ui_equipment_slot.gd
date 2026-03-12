extends CenterContainer

class_name UIEquipmentSlot

@export var slot_type: EquipableItem.TypeSlot
@onready var icon: TextureRect = $Icon


func display_item(item: EquipableItem):
    if item:
        icon.texture = item.icon
        icon.visible = true
        tooltip_text = item.name + "\nPower: " + str(item.power_bonus)
    else:
        icon.texture = null
        icon.visible = false
        tooltip_text = "Empty Slot"
