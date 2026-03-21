extends MarginContainer

class_name UIAbilityPanel

@onready var ability_container: HBoxContainer = $AbilityContainer
var scene_button: PackedScene = preload("res://scenes/ui/button_ui_skill.tscn")


func _ready() -> void:
    ManagerTurnsAndRounds.active_unit_changed.connect(on_active_unit_changed)
    return


func on_active_unit_changed(unit: Unit) -> void:
    var abilities: Array[Ability] = unit.mgr_abilities.abilities.values()
    var abilities_container_size: int = ability_container.get_child_count()
    var abilities_size: int = abilities.size()
    for i in range(abilities_container_size):
        if i < abilities_size:
            var ability: Ability = abilities[i]
            var button: ButtonUISkill = ability_container.get_child(i) as ButtonUISkill
            button.skill_tex.texture = ability.icon
        else:
            var button: ButtonUISkill = ability_container.get_child(i) as ButtonUISkill
            button.skill_tex.texture = null
    return
