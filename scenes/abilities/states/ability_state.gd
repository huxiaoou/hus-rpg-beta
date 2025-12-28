extends Node

class_name AbilityState

@export var state_name: String
var ability: Ability = null


func setup(_ability: Ability) -> void:
    ability = _ability


func enter() -> void:
    pass


func exit() -> void:
    pass


func process(_delta: float) -> void:
    pass
