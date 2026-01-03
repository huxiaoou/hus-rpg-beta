extends Node

class_name ManagerAbilities

@export_group("Abilities")
@export var scenes_abilities: Array[PackedScene] = []

@onready var abilities_node: Node = $AbilitiesNode
@onready var aplayer_gmply: APlayerUnitGamePlay = $APlayerUnitGamePlay

var owner_unit: Unit
var active_ability: Ability = null
var abilities: Dictionary[String, Ability] = { }
var is_active: bool:
    get:
        return active_ability != null


func setup(_owner_unit: Unit) -> void:
    owner_unit = _owner_unit
    for scene_ability in scenes_abilities:
        var ability = scene_ability.instantiate()
        abilities_node.add_child(ability)
        ability.setup(owner_unit, connect_ability)
        abilities[ability.id] = ability
    return


func connect_ability(ability: Ability) -> void:
    ability.selected.connect(on_ability_selected)
    ability.canceled.connect(on_ability_canceled)
    ability.warning.connect(on_ability_warning)
    ability.deactivated.connect(on_ability_deactivated)
    return


func on_ability_selected() -> void:
    aplayer_gmply.play_selected()
    return


func on_ability_canceled() -> void:
    aplayer_gmply.play_canceled()
    return


func on_ability_warning() -> void:
    aplayer_gmply.play_warning()
    return


func get_ability(id: String) -> Ability:
    return abilities.get(id)


func activiate_ability(id: String) -> bool:
    active_ability = get_ability(id)
    if active_ability == null:
        aplayer_gmply.play_warning()
        print("There is ability named '%s'to activate" % id)
        return false
    active_ability.activate()
    return true


func on_ability_deactivated():
    active_ability = null
    return


func show_active_ability() -> void:
    aplayer_gmply.play_warning()
    print("%s has ability %s as active" % [owner_unit.name, active_ability.short_name])
    return
