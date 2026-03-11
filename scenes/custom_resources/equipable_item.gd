extends Resource

class_name EquipableItem

enum TypeSlot { WEAPON, ARMOR, ACCESSORY }

@export var name: String = "New Item"
@export var icon: Texture2D
@export var slot: TypeSlot
@export var power_bonus: int = 0
@export var defense_bonus: int = 0
