extends AudioStreamPlayer2D

class_name AudioPlayerForAbility

@export_group("Streams")

@export var selected: AudioStream
@export var canceled: AudioStream
@export var warning: AudioStream


func _play_stream(s: AudioStream) -> void:
    if stream != s:
        stream = s
    play()
    return


func play_selected() -> void:
    _play_stream(selected)
    return


func play_canceled() -> void:
    _play_stream(canceled)
    return


func play_warning() -> void:
    _play_stream(warning)
    return
