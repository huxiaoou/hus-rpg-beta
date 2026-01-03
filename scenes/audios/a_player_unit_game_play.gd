extends Node

class_name APlayerUnitGamePlay

@export_group("Audios")
@export var selected: AudioStream
@export var canceled: AudioStream
@export var warning: AudioStream
@export var unit_walk: AudioStream
@export var unit_sword: AudioStream

@onready var a_player: AudioStreamPlayer2D = $APlayer

# --------------
# --- Audios ---
# --------------


func _play(stream: AudioStream) -> void:
    if a_player.stream != stream:
        a_player.stop()
        a_player.stream = stream
    a_player.play()
    return


func play_selected() -> void:
    _play(selected)
    return


func play_canceled() -> void:
    _play(canceled)
    return


func play_warning() -> void:
    _play(warning)
    return


func play_unit_walk() -> void:
    _play(unit_walk)
    return


func play_unit_sword() -> void:
    _play(unit_sword)
    return
