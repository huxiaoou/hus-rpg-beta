extends TextureRect

class_name MainMenu

@onready var start_button: ButtonUI = $VBoxContainer/StartButton
@onready var load_button: ButtonUI = $VBoxContainer/LoadButton
@onready var options_button: ButtonUI = $VBoxContainer/OptionsButton
@onready var exit_button: ButtonUI = $VBoxContainer/ExitButton

@onready var aplayer_sfx: AudioStreamPlayer2D = $aplayer_sfx
@onready var aplayer_bg_music: AudioStreamPlayer2D = $aplayer_bg_music

@onready var ui_options: TextureRect = $UIOptions


func _ready() -> void:
    connect_buttion_to_aplayer(start_button)
    connect_buttion_to_aplayer(load_button)
    connect_buttion_to_aplayer(options_button)
    connect_buttion_to_aplayer(exit_button)
    start_button.call_deferred("grab_focus")
    aplayer_bg_music.play()
    return


func connect_buttion_to_aplayer(btn: Button) -> void:
    btn.mouse_entered.connect(play_sfx)
    btn.focus_entered.connect(play_sfx)
    return


func play_sfx() -> void:
    aplayer_sfx.play()
    return


func _on_start_button_pressed() -> void:
    play_sfx()
    await get_tree().create_timer(0.2).timeout
    SceneChanger.change_scene("res://scenes/levels/level_battle.tscn")


func _on_exit_button_pressed() -> void:
    play_sfx()
    await get_tree().create_timer(0.2).timeout
    get_tree().quit()
    return


func _on_options_button_pressed() -> void:
    play_sfx()
    ui_options.visible = true
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(ui_options, "modulate:a", 1.0, 0.5)
    return
