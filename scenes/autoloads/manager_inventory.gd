extends Node

signal inventory_updated

enum TypeSortBy {
    VALUE,
    WEIGHT,
}

@export var items: Array[EquipableItem] = []
var sort_func: Callable = EquipableItem.compare_items_by_value


func add_item(item: EquipableItem):
    if item:
        items.append(item)
        items.sort_custom(sort_func)
        inventory_updated.emit()
    return


func remove_item(item: EquipableItem):
    if item:
        items.erase(item)
        items.sort_custom(sort_func)
        inventory_updated.emit()
    return


func sort_items():
    items.sort_custom(sort_func)
    inventory_updated.emit()
    return


func set_sort_func_by_value() -> void:
    sort_func = EquipableItem.compare_items_by_value
    return


func set_sort_func_by_weight() -> void:
    sort_func = EquipableItem.compare_items_by_weight
    return


func set_sort_func_by_power_bonus() -> void:
    sort_func = EquipableItem.compare_items_by_power_bonus
    return


func set_sort_func_by_defense_bonus() -> void:
    sort_func = EquipableItem.compare_items_by_defense_bonus
    return


func set_sort_func_by_name() -> void:
    sort_func = EquipableItem.compare_items_by_name
    return
