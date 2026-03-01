extends Node

class_name ManagerAbilities

@export_group("Abilities")
@export var scenes_abilities: Array[PackedScene] = []
@onready var abilities_node: Node = $AbilitiesNode
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
    ability.activated.connect(on_ability_activated)
    ability.deactivated.connect(on_ability_deactivated)
    return


func get_ability(id: String) -> Ability:
    return abilities.get(id)


func on_ability_activated(ability: Ability) -> void:
    selected_ability = ability
    return


func on_ability_deactivated(_ability: Ability) -> void:
    selected_ability = null
    return


func has_ability_selected() -> bool:
    return selected_ability != null


func show_active_ability() -> void:
    selected_ability.audio_player.play_warning()
    print("%s has ability %s as active" % [owner_unit.name, selected_ability.short_name])
    return


func find_best_ability_to_cast() -> Ability:
    var best_ability: Ability = null
    for ability in abilities.values():
        ability.think()
        if best_ability == null or ability.is_better_than(best_ability):
            best_ability = ability
    return best_ability
