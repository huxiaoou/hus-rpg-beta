extends AudioStreamPlayer2D

class_name AudioPlayerForUnit

@export_group("Audios")
@export var walk: AudioStream
@export var melee: AudioStream
@export var projectile: AudioStream


# --------------
# --- Audios ---
# --------------


func _play(s: AudioStream) -> void:
    if stream != s:
        stream = s
    play()
    return


func play_walk() -> void:
    _play(walk)
    return


func play_melee() -> void:
    _play(melee)
    return


func play_projectile() -> void:
    _play(projectile)
    return
