extends Node

class_name APlayerUnitGamePlay

@export_group("Audios")
@export var selected: AudioStream
@export var canceled: AudioStream
@export var warning: AudioStream

@onready var a_player: AudioStreamPlayer2D = $APlayer

var sfx_streams: Dictionary[String, AudioStream] = { }


func _ready() -> void:
    sfx_streams = {
        "selected": selected,
        "canceled": canceled,
        "warning": warning,
    }
    return

# --------------
# --- Audios ---
# --------------


func _play(stream_name: String) -> void:
    a_player.stop()
    a_player.stream = sfx_streams.get(stream_name)
    a_player.play()
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
