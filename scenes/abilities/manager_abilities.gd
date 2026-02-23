extends Node

class_name ManagerAbilities

@export_group("Abilities")
@export var scenes_abilities: Array[PackedScene] = []

@onready var abilities_node: Node = $AbilitiesNode
@onready var states_node: Node = $StatesNode
@onready var aplayer_gmply: APlayerUnitGamePlay = $APlayerUnitGamePlay
@onready var owner_unit: Unit = get_parent()

var active_ability: Ability = null
var curr_state: AbilityState = null

var abilities: Dictionary[String, Ability] = { }
var states: Dictionary[AbilityState.State, AbilityState] = { }

var is_active: bool:
    get:
        return active_ability != null


func _ready() -> void:
    for scene_ability in scenes_abilities:
        var ability: Ability = scene_ability.instantiate()
        abilities_node.add_child(ability)
        ability.setup(owner_unit, connect_ability)
        abilities[ability.id] = ability
    for state: AbilityState in states_node.get_children():
        states[state.state_id] = state
    curr_state = states[AbilityState.State.DEACTIVATED]
    return


func connect_ability(ability: Ability) -> void:
    ability.selected.connect(on_ability_selected)
    ability.canceled.connect(on_ability_canceled)
    ability.warning.connect(on_ability_warning)
    ability.deactivated.connect(on_ability_deactivated)
    return


func _process(delta: float) -> void:
    if curr_state != null:
        curr_state.process(delta)
    return


func _physics_process(delta: float) -> void:
    if curr_state != null:
        curr_state.physics_process(delta)
    return


func on_state_changed(state_id: AbilityState.State) -> void:
    var new_state: AbilityState = states.get(state_id)
    if new_state == null:
        return
    curr_state.exit()
    curr_state = new_state
    curr_state.enter()
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
        print("There is no ability named '%s' to activate" % id)
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
