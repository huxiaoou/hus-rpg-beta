extends Control

class_name UIAvatar

@onready var timer: Timer = $Timer
@onready var bar_health_bg: TextureProgressBar = $TextureAvatar/BarHealthBg
@onready var bar_health_fg: TextureProgressBar = $TextureAvatar/BarHealthFg
@onready var bar_magicka_bg: TextureProgressBar = $TextureAvatar/BarMagickaBg
@onready var bar_magicka_fg: TextureProgressBar = $TextureAvatar/BarMagickaFg


func _ready() -> void:
	bar_health_bg.value = bar_health_bg.max_value
	bar_health_fg.value = bar_health_fg.max_value


func _decrease_bar(
		bg: TextureProgressBar,
		fg: TextureProgressBar,
		new_val: float,
		duration_seconds: float,
		delay_sceonds: float = 0.3,
		blink_times: int = 3,
		blink_attitude: Vector2 = Vector2(0.5, 1.0),
		blink_duration_seconds: float = 0.05,
):
	fg.value = new_val
	timer.start(delay_sceonds)
	await timer.timeout
	var tw: Tween = create_tween()
	for t: int in range(blink_times):
		tw.tween_property(bg, "self_modulate:a", blink_attitude.x, blink_duration_seconds)
		tw.tween_property(bg, "self_modulate:a", blink_attitude.y, blink_duration_seconds)
	tw.tween_property(bg, "value", new_val, duration_seconds)
	return


func _increase_bar(
		bg: TextureProgressBar,
		fg: TextureProgressBar,
		new_val: float,
		duration_seconds: float,
		delay_sceonds: float = 0.3,
		blink_times: int = 3,
		blink_attitude: Vector2 = Vector2(0.5, 1.0),
		blink_duration_seconds: float = 0.05,
):
	bg.value = new_val
	timer.start(delay_sceonds)
	await timer.timeout
	var tw: Tween = create_tween()
	for t: int in range(blink_times):
		tw.tween_property(bg, "self_modulate:a", blink_attitude.x, blink_duration_seconds)
		tw.tween_property(bg, "self_modulate:a", blink_attitude.y, blink_duration_seconds)
	tw.tween_property(fg, "value", new_val, duration_seconds)
	return


func _decrease_health(new_health: float, duration_seconds: float) -> void:
	_decrease_bar(bar_health_bg, bar_health_fg, new_health, duration_seconds)
	return


func _increase_health(new_health: float, duration_seconds: float) -> void:
	_increase_bar(bar_health_bg, bar_health_fg, new_health, duration_seconds)
	return


func _decrease_magicka(new_magicka: float, duration_seconds: float) -> void:
	_decrease_bar(bar_magicka_bg, bar_magicka_fg, new_magicka, duration_seconds)
	return


func _increase_magicka(new_magicka: float, duration_seconds: float) -> void:
	_increase_bar(bar_magicka_bg, bar_magicka_fg, new_magicka, duration_seconds)
	return


func on_health_changed(new_health: float) -> void:
	if new_health < bar_health_fg.value:
		_decrease_health(new_health, 0.5)
	elif new_health > bar_health_fg.value:
		_increase_health(new_health, 0.5)
	return


func on_magicka_changed(new_magicka: float) -> void:
	if new_magicka < bar_magicka_fg.value:
		_decrease_magicka(new_magicka, 0.5)
	elif new_magicka > bar_magicka_fg.value:
		_increase_magicka(new_magicka, 0.5)
	return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_add"):
		on_health_changed(clampf(bar_health_fg.value + 20, bar_health_fg.min_value, bar_health_fg.max_value))
		on_magicka_changed(clampf(bar_magicka_fg.value + 40, bar_magicka_fg.min_value, bar_magicka_fg.max_value))
	elif event.is_action_pressed("test_subtract"):
		on_health_changed(clampf(bar_health_fg.value - 20, bar_health_fg.min_value, bar_health_fg.max_value))
		on_magicka_changed(clampf(bar_magicka_fg.value - 40, bar_magicka_fg.min_value, bar_magicka_fg.max_value))
	return
