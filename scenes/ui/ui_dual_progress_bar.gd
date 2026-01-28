extends Control

class_name UIDualProgressBar

@export_group("Textures")
@export var progress_texture: Texture2D
@export var fore_color: Color = Color.WHITE
@export var back_color: Color = Color.WHITE

@export_group("Values")
@export var dual_pb_val: float = 100:
    set(value):
        dual_pb_val = value
        label.text = "%d/%d" % [dual_pb_val, dual_pb_max_val]
@export var dual_pb_max_val: float = 100
@export var dual_pb_min_val: float = 0
@export var dual_pb_step: float = 1

@onready var pb_back: TextureProgressBar = $PBBack
@onready var pb_fore: TextureProgressBar = $PBFore
@onready var label: Label = $Label


func init_pb_texture(pb: TextureProgressBar, pb_texture: Texture2D, pb_color: Color) -> void:
    pb.texture_progress = pb_texture
    pb.tint_progress = pb_color
    pb.value = dual_pb_val
    pb.max_value = dual_pb_max_val
    pb.min_value = dual_pb_min_val
    pb.step = dual_pb_step
    label.custom_minimum_size.x = pb_fore.get_minimum_size().x * 0.9
    return


func init_pb_value(pb: TextureProgressBar, value: float, max_value: float, min_value: float, step: float) -> void:
    pb.value = value
    pb.max_value = max_value
    pb.min_value = min_value
    pb.step = step
    return


func init_value(value: float, max_value: float, min_value: float, step: float) -> void:
    dual_pb_max_val = max_value
    dual_pb_min_val = min_value
    dual_pb_step = step
    dual_pb_val = value
    init_pb_value(pb_back, value, max_value, min_value, step)
    init_pb_value(pb_fore, value, max_value, min_value, step)
    return


func _ready() -> void:
    dual_pb_val = dual_pb_val
    init_pb_texture(pb_back, progress_texture, back_color)
    init_pb_texture(pb_fore, progress_texture, fore_color)
    return


func _decrease_bar(
        new_val: float,
        duration_seconds: float,
        delay_sceonds: float = 0.3,
        blink_times: int = 3,
        blink_attitude: Vector2 = Vector2(0.5, 1.0),
        blink_duration_seconds: float = 0.05,
):
    pb_fore.value = new_val
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tw.tween_interval(delay_sceonds)
    for t: int in range(blink_times):
        tw.tween_property(pb_back, "self_modulate:a", blink_attitude.x, blink_duration_seconds)
        tw.tween_property(pb_back, "self_modulate:a", blink_attitude.y, blink_duration_seconds)
    tw.tween_property(pb_back, "value", new_val, duration_seconds)
    tw.parallel().tween_property(self, "dual_pb_val", new_val, duration_seconds)
    return


func _increase_bar(
        new_val: float,
        duration_seconds: float,
        delay_sceonds: float = 0.3,
        blink_times: int = 3,
        blink_attitude: Vector2 = Vector2(0.5, 1.0),
        blink_duration_seconds: float = 0.05,
):
    pb_back.value = new_val
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    tw.tween_interval(delay_sceonds)
    for t: int in range(blink_times):
        tw.tween_property(pb_back, "self_modulate:a", blink_attitude.x, blink_duration_seconds)
        tw.tween_property(pb_back, "self_modulate:a", blink_attitude.y, blink_duration_seconds)
    tw.tween_property(pb_fore, "value", new_val, duration_seconds)
    tw.parallel().tween_property(self, "dual_pb_val", new_val, duration_seconds)
    return


func on_value_changed(new_value: float) -> void:
    var clamped_value: float = clampf(new_value, dual_pb_min_val, dual_pb_max_val)
    if clamped_value < dual_pb_val:
        _decrease_bar(clamped_value, 0.5)
    elif clamped_value > dual_pb_val:
        _increase_bar(clamped_value, 0.5)
    #dual_pb_val = clamped_value
    return
