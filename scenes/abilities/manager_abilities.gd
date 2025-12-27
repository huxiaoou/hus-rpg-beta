extends Node

class_name ManagerAbilities

@export_group("Abilities")
@export var scenes_abilities: Array[PackedScene] = []

@export_group("Audios")
@export var selected_stream: AudioStream
@export var canceled_stream: AudioStream
@export var warning_stream: AudioStream

@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@onready var abilities_node: Node = $AbilitiesNode

var owner_unit: Unit
var active_ability: Ability = null
var abilities: Dictionary[String, Ability] = { }
var sfx_streams: Dictionary[String, AudioStream] = { }


func setup(_owner_unit: Unit) -> void:
    owner_unit = _owner_unit
    for scene_ability in scenes_abilities:
        var ability = scene_ability.instantiate()
        abilities_node.add_child(ability)
        ability.setup(owner_unit, deactivate_ability, connect_ability)
        abilities[ability.id] = ability
    sfx_streams = {
        "selected": selected_stream,
        "canceled": canceled_stream,
        "warning": warning_stream,
    }
    return


func connect_ability(ability: Ability) -> void:
    ability.selected.connect(on_ability_selected)
    ability.canceled.connect(on_ability_canceled)
    ability.warning.connect(on_ability_warning)
    return


func on_ability_selected() -> void:
    play_selected()
    return


func on_ability_canceled() -> void:
    play_canceled()
    return


func on_ability_warning() -> void:
    play_warning()
    return


func get_ability(id: String) -> Ability:
    return abilities.get(id)


func activiate_ability(id: String) -> bool:
    active_ability = get_ability(id)
    if active_ability == null:
        play_warning()
        print("There is ability named '%s'to activate" % id)
        return false
    active_ability.activate()
    return true


func deactivate_ability():
    if active_ability == null:
        play_warning()
        print("There is no active ability to deactivate")
        return
    active_ability.deactivate()
    active_ability = null
    return

# --------------
# --- Audios ---
# --------------


func _play(stream_name: String) -> void:
    sfx_player.stop()
    sfx_player.stream = sfx_streams.get(stream_name)
    sfx_player.play()
    return


func play_selected() -> void:
    _play("selected")
    return


func play_canceled() -> void:
    _play("canceled")
    return


func play_warning() -> void:
    _play("warning")
    return
