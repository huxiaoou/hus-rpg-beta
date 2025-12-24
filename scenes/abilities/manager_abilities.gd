extends Node

class_name ManagerAbilities

var owner_unit: Unit
var active_ability: Ability = null
var abilities: Dictionary[String, Ability] = { }


func setup(_owner_unit: Unit) -> void:
    owner_unit = _owner_unit
    for ability: Ability in get_children():
        if is_instance_of(ability, Ability):
            ability.setup(owner_unit)
            abilities[ability.id] = ability


func get_ability(id: String) -> Ability:
    return abilities.get(id)
