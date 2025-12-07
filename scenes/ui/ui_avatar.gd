extends Control

class_name UIAvatar

@onready var bar_health_bg: TextureProgressBar = $TextureAvatar/BarHealthBg
@onready var bar_health_fg: TextureProgressBar = $TextureAvatar/BarHealthFg
@onready var timer: Timer = $Timer


func _ready() -> void:
	bar_health_bg.value = bar_health_bg.max_value
	bar_health_fg.value = bar_health_fg.max_value


func _increase_health(health: float, duration_seconds: float = 0.5) -> void:
	bar_health_fg.value = health
	timer.start(0.3)
	await timer.timeout
	var tw: Tween = create_tween()
	for _t in range(3):
		tw.tween_property(bar_health_bg, "self_modulate:a", 0.5, 0.05)
		tw.tween_property(bar_health_bg, "self_modulate:a", 1.0, 0.05)
	tw.tween_property(bar_health_bg, "value", health, duration_seconds)
	return


func _decrease_health(health: float, duration_seconds: float = 0.5) -> void:
	bar_health_bg.value = health
	timer.start(0.3)
	await timer.timeout
	var tw: Tween = create_tween()
	for _t in range(3):
		tw.tween_property(bar_health_bg, "self_modulate:a", 0.5, 0.05)
		tw.tween_property(bar_health_bg, "self_modulate:a", 1.0, 0.05)
	tw.tween_property(bar_health_fg, "value", health, duration_seconds)
	return


func on_health_changed(health: float) -> void:
	if health < bar_health_fg.value:
		_increase_health(health)
	elif health > bar_health_fg.value:
		_decrease_health(health)
	return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_add"):
		print("add health")
		on_health_changed(clampf(bar_health_fg.value + 20, bar_health_fg.min_value, bar_health_fg.max_value))
	elif event.is_action_pressed("test_subtract"):
		print("subtract health")
		on_health_changed(clampf(bar_health_fg.value - 20, bar_health_fg.min_value, bar_health_fg.max_value))
	return
