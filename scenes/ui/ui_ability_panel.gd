extends MarginContainer

class_name UIAbilityPanel

@onready var ability_container: HBoxContainer = $AbilityContainer

var scene_button: PackedScene = preload("res://scenes/ui/button_ui_skill.tscn")
var curr_unit: Unit = null


func _ready() -> void:
    ManagerTurnsAndRounds.active_unit_changed.connect(on_active_unit_changed)
    return


func disconnect_from_curr_unit() -> void:
    if curr_unit.is_ai():
        return
    var abilities_container_size: int = ability_container.get_child_count()
    var abilities: Array[Ability] = curr_unit.mgr_abilities.abilities.values()
    var abilities_size: int = abilities.size()
    for i in range(abilities_container_size):
        if i < abilities_size:
            var button: ButtonUISkill = ability_container.get_child(i) as ButtonUISkill
            abilities[i].disconnect_from_ui_button_skill(button)
    return


func connect_to_curr_unit() -> void:
    if curr_unit.is_ai():
        visible = false
        return
    visible = true
    var abilities_container_size: int = ability_container.get_child_count()
    var abilities: Array[Ability] = curr_unit.mgr_abilities.abilities.values()
    var abilities_size: int = abilities.size()
    for i in range(abilities_container_size):
        if i < abilities_size:
            var button: ButtonUISkill = ability_container.get_child(i) as ButtonUISkill
            abilities[i].connect_to_ui_button_skill(button)
        else:
            var button: ButtonUISkill = ability_container.get_child(i) as ButtonUISkill
            button.set_default()
    return


func on_active_unit_changed(unit: Unit) -> void:
    if curr_unit:
        disconnect_from_curr_unit()
    curr_unit = unit
    connect_to_curr_unit()
    return
