extends Node

class_name Ability

@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var unit_owner: Unit = null
var is_casting: bool = false


func setup(_unit_owner: Unit) -> void:
	unit_owner = _unit_owner
	is_casting = false
