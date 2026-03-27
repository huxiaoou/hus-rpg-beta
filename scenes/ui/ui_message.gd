class_name UIMessage
extends TextureRect

@onready var label: Label = $MarginContainer/Label


func init(order: int, sep: float) -> void:
    label.text = ""
    modulate.a = 0.5
    position.y += order * (size.y + sep)
    return


func setup(msg: String) -> void:
    label.text = msg


func fade_in() -> void:
    var tween: Tween = create_tween()
    tween.tween_property(self, "modulate:a", 1.0, 0.5).from(0.0)
    return
