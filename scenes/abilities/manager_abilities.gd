extends Node

class_name ManagerAbilities

@export_group("Abilities")
@export var scenes_abilities: Array[PackedScene] = []
@onready var abilities_node: Node = $AbilitiesNode
@onready var aplayer_gmply: APlayerUnitGamePlay = $APlayerUnitGamePlay
@onready var owner_unit: Unit = get_parent()

var selected_ability: Ability = null
var abilities: Dictionary[String, Ability] = { }
var has_selected_ability: bool:
    get:
        return selected_ability != null


func _ready() -> void:
    for scene_ability in scenes_abilities:
        var ability: Ability = scene_ability.instantiate()
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


func on_ability_deactivated():
    selected_ability = null
    return


func show_active_ability() -> void:
    aplayer_gmply.play_warning()
    print("%s has ability %s as active" % [owner_unit.name, selected_ability.short_name])
    return
