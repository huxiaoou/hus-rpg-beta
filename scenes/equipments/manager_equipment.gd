extends Node

class_name ManagerEquipment

@export_group("SFX")
@export var astream_equip: AudioStream
@export var astream_unequip: AudioStream

@onready var astream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var equipped_items: Dictionary[EquipableItem.TypeSlot, EquipableItem] = { }

signal equipment_changed()


func has_equipped(slot: EquipableItem.TypeSlot) -> bool:
    return equipped_items.has(slot)


func equip(item: EquipableItem) -> void:
    if equipped_items.has(item.slot):
        unequip(item.slot)

    equipped_items[item.slot] = item
    equipment_changed.emit()
    play_sfx_equip()
    print("Equipped item: %s in slot %s" % [item.name, item.slot])
    return


func unequip(slot: EquipableItem.TypeSlot) -> EquipableItem:
    if not equipped_items.has(slot):
        return null

    var unequipped_item: EquipableItem = equipped_items[slot]
    equipped_items.erase(slot)
    ManagerInventory.add_item(unequipped_item)
    equipment_changed.emit()
    play_sfx_unequip()
    print("Unequipped item: %s from slot %s" % [unequipped_item.name, slot])
    return unequipped_item


func get_power_bonus() -> int:
    var total_bonus: int = 0
    for item in equipped_items.values():
        total_bonus += item.power_bonus
    return total_bonus


func get_defense_bonus() -> int:
    var total_bonus: int = 0
    for item in equipped_items.values():
        total_bonus += item.defense_bonus
    return total_bonus


func play_sfx_equip() -> void:
    astream_player.stream = astream_equip
    astream_player.play()
    return


func play_sfx_unequip() -> void:
    astream_player.stream = astream_unequip
    astream_player.play()
    return
