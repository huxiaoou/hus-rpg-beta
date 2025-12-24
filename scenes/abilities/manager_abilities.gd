extends Node

class_name ManagerAbilities

var owner_unit: Unit
var active_ability: Ability = null
var abilities: Dictionary[String, Ability] = { }


func setup(_owner_unit: Unit) -> void:
    owner_unit = _owner_unit
    for ability: Ability in get_children():
        if is_instance_of(ability, Ability):
            ability.setup(owner_unit, set_active_ability)
            abilities[ability.id] = ability


func get_ability(id: String) -> Ability:
    return abilities.get(id)


func set_active_ability(ability: Ability) -> void:
    if ability == null:
        active_ability.is_active = false
    active_ability = ability
    return


func activiate_ability(id: String) -> bool:
    active_ability = get_ability(id)
    if active_ability == null:
        return false
    active_ability.is_active = true
    print("Active ability %s" % active_ability.short_name)
    return true
