extends Node

signal inventory_updated

@export var items: Array[EquipableItem] = []


func add_item(item: EquipableItem):
    if item:
        items.append(item)
        inventory_updated.emit()
    return


func remove_item(item: EquipableItem):
    if item:
        items.erase(item)
        inventory_updated.emit()
    return


func sort_by_value():
    items.sort_custom(EquipableItem.compare_items_by_value)
    inventory_updated.emit()
    return


func sort_by_weight():
    items.sort_custom(EquipableItem.compare_items_by_weight)
    inventory_updated.emit()
    return


func sort_by_power_bonus():
    items.sort_custom(EquipableItem.compare_items_by_power_bonus)
    inventory_updated.emit()
    return


func sort_by_defense_bonus():
    items.sort_custom(EquipableItem.compare_items_by_defense_bonus)
    inventory_updated.emit()
    return


func sort_by_name():
    items.sort_custom(EquipableItem.compare_items_by_name)
    inventory_updated.emit()
    return
