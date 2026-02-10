extends Node2D

class_name Projectile

signal impacted()

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
    impacted.connect(on_impacted)


func on_impacted(unit: Unit) -> void:
    audio_stream_player_2d.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
    print("Body entered: %s" % body.name)
    impacted.emit(body.get_parent())
