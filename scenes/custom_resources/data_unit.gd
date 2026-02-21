extends Resource

class_name DataUnit

signal health_changed(health: int)
signal magicka_changed(magicka: int)
signal stamina_changed(stamina: int)
signal resolve_changed(resolve: int)

enum GroupFlag {
    ALLY,
    ENEMY,
    NEUTRAL,
}

@export_group("UI")
@export var name: String
@export var avatar: Texture2D

@export_group("Attributes")
@export var group_flag: GroupFlag = GroupFlag.NEUTRAL
@export var level: int = 1
@export var health: int = 100
@export var stamina: int = 100
@export var magicka: int = 100
@export var resolve: int = 100
@export var max_health: int = 100
@export var max_stamina: int = 100
@export var max_magicka: int = 100
@export var max_resolve: int = 100
@export var attack: int = 24
@export var armor: int = 8
@export var initiative: int = 12

@export_group("Init")
@export var init_cell: Vector2i


func change_health(delta_health: int) -> void:
    health = clampi(health + delta_health, 0, max_health)
    health_changed.emit(health)
    return


func change_stamina(delta_stamina: int) -> void:
    stamina = clampi(stamina + delta_stamina, 0, max_stamina)
    stamina_changed.emit(stamina)
    return


func change_magicka(delta_magicka: int) -> void:
    magicka = clampi(magicka + delta_magicka, 0, max_magicka)
    magicka_changed.emit(magicka)
    return


func change_resolve(delta_resolve: int) -> void:
    resolve = clampi(resolve + delta_resolve, 0, max_resolve)
    resolve_changed.emit(resolve)
    return


func has_greater_turn_order(other: DataUnit) -> bool:
    if initiative != other.initiative:
        return initiative > other.initiative
    if level != other.level:
        return level > other.level
    if group_flag != other.group_flag:
        return group_flag < other.group_flag
    if attack != other.attack:
        return attack > other.attack
    if armor != other.armor:
        return armor > other.armor
    if health != other.health:
        return health > other.health
    if stamina != other.stamina:
        return stamina > other.stamina
    if magicka != other.magicka:
        return magicka > other.magicka
    if resolve != other.resolve:
        return resolve > other.resolve
    return name > other.name
