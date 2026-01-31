extends CenterContainer

class_name UIFloatingHealthBar

@onready var bar: TextureProgressBar = $Bar
@onready var label: Label = $Label


func init_value(value: float, max_value: float, min_value: float, step: float) -> void:
    bar.value = value
    bar.max_value = max_value
    bar.min_value = min_value
    bar.step = step
    update_label(value)
    return


func update_label(new_val: float) -> void:
    label.text = "%d/%d" % [new_val, bar.max_value]
    return


func _tween_bar(
        new_val: float,
        duration_seconds: float,
        delay_sceonds: float = 0.3,
        blink_times: int = 3,
        blink_attitude: Vector2 = Vector2(0.5, 1.0),
        blink_duration_seconds: float = 0.05,
):
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_interval(delay_sceonds)
    for t: int in range(blink_times):
        tw.tween_property(bar, "self_modulate:a", blink_attitude.x, blink_duration_seconds)
        tw.tween_property(bar, "self_modulate:a", blink_attitude.y, blink_duration_seconds)
    tw.tween_property(bar, "value", new_val, duration_seconds)
    tw.parallel().tween_method(update_label, bar.value, new_val, duration_seconds)
    await tw.finished
    return


func on_value_changed(new_value: float) -> void:
    _tween_bar(new_value, 0.5, 0.0)
    return
