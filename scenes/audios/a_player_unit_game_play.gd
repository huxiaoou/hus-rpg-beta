extends Node

class_name APlayerUnitGamePlay

@export_group("Audios")
@export var unit_walk: AudioStream
@export var unit_sword: AudioStream
@export var unit_projectile: AudioStream

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


func play_unit_walk() -> void:
    _play(unit_walk)
    return


func play_unit_sword() -> void:
    _play(unit_sword)
    return


func play_unit_projectile() -> void:
    _play(unit_projectile)
    return
