extends Resource

class_name EquipableItem

enum TypeSlot { WEAPON, ARMOR, ACCESSORY }

@export var name: String = "New Item"
@export var icon: Texture2D
@export var slot: TypeSlot
@export var power_bonus: int = 0
@export var defense_bonus: int = 0
@export var weight: float = 0.5
@export var value: float = 0


static func compare_items_by_value(item_a: EquipableItem, item_b: EquipableItem) -> bool:
    if item_a.value != item_b.value:
        return item_a.value > item_b.value
    return item_a.name > item_b.name


static func compare_items_by_weight(item_a: EquipableItem, item_b: EquipableItem) -> bool:
    if item_a.weight != item_b.weight:
        return item_a.weight > item_b.weight
    return item_a.name > item_b.name


static func compare_items_by_power_bonus(item_a: EquipableItem, item_b: EquipableItem) -> bool:
    if item_a.power_bonus != item_b.power_bonus:
        return item_a.power_bonus > item_b.power_bonus
    return item_a.name > item_b.name


static func compare_items_by_defense_bonus(item_a: EquipableItem, item_b: EquipableItem) -> bool:
    if item_a.defense_bonus != item_b.defense_bonus:
        return item_a.defense_bonus > item_b.defense_bonus
    return item_a.name > item_b.name


static func compare_items_by_name(item_a: EquipableItem, item_b: EquipableItem) -> bool:
    return item_a.name > item_b.name
