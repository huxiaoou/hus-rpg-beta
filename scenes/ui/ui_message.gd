class_name UIMessage
extends TextureRect

signal fade_in_finished(ui: UIMessage)
signal fade_out_finished(ui: UIMessage)

@onready var label: Label = $MarginContainer/Label
@onready var aplayer: AudioStreamPlayer = $AudioStreamPlayer

const DURATION: float = 2.0


func init(order: int, sep: float) -> void:
    label.text = ""
    modulate.a = 0.0
    position.y += order * (size.y + sep)
    fade_in_finished.connect(on_fade_in_finished)
    return


func setup(msg: String) -> void:
    label.text = msg


func fade_in() -> void:
    aplayer.play()
    var tween: Tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate:a", 1.0, 0.5).from(0.0)
    await tween.finished
    fade_in_finished.emit(self)
    return


func on_fade_in_finished(ui: UIMessage) -> void:
    await get_tree().create_timer(DURATION).timeout
    ui.fade_out()
    return


func fade_out() -> void:
    var tween: Tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "modulate:a", 0.0, 0.5).from(1.0)
    await tween.finished
    fade_out_finished.emit(self)
    return
