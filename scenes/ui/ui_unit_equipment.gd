extends TextureRect

class_name UIUnitEquipment

signal unit_set(unit: Unit)

@onready var avatar: TextureRect = $HBoxContainer/Avatar
@onready var slot_weapon: UIEquipmentSlot = $SlotWeapon
@onready var slot_armor: UIEquipmentSlot = $SlotArmor
@onready var slot_accessory: UIEquipmentSlot = $SlotAccessory
@onready var btn_prev: Button = $HBoxContainer/BtnPrev
@onready var btn_next: Button = $HBoxContainer/BtnNext

var unit: Unit = null


func _ready() -> void:
    ManagerTurnsAndRounds.units_registered.connect(on_units_registered)
    return


func on_units_registered() -> void:
    set_unit(ManagerTurnsAndRounds.regiestered_allies()[0])
    return


func set_unit(_unit: Unit) -> void:
    unit = _unit
    avatar.texture = unit.data.avatar
    slot_weapon.unit = unit
    slot_armor.unit = unit
    slot_accessory.unit = unit
    unit.manager_equipment.equipment_changed.connect(refresh_ui)
    refresh_ui()
    unit_set.emit(unit)
    return


func refresh_ui() -> void:
    var gear = unit.manager_equipment.equipped_items
    slot_weapon.display_item(gear.get(EquipableItem.TypeSlot.WEAPON))
    slot_armor.display_item(gear.get(EquipableItem.TypeSlot.ARMOR))
    slot_accessory.display_item(gear.get(EquipableItem.TypeSlot.ACCESSORY))
    return


func _on_btn_prev_pressed() -> void:
    set_unit(ManagerTurnsAndRounds.find_next_ally(unit, -1))
    return


func _on_btn_next_pressed() -> void:
    set_unit(ManagerTurnsAndRounds.find_next_ally(unit, 1))
    return
