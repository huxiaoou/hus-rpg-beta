extends TextureRect

class_name UIOptions

@onready var aplayer: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
    visible = false
    modulate.a = 0


func _on_button_ui_pressed() -> void:
    aplayer.play()
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "modulate:a", 0.0, 0.5)
    await tw.finished
    visible = false
    return
