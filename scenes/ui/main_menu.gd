extends TextureRect

class_name MainMenu

@onready var start_button: ButtonUI = $VBoxContainer/StartButton
@onready var load_button: ButtonUI = $VBoxContainer/LoadButton
@onready var options_button: ButtonUI = $VBoxContainer/OptionsButton
@onready var exit_button: ButtonUI = $VBoxContainer/ExitButton

@onready var aplayer_sfx: AudioStreamPlayer2D = $aplayer_sfx
@onready var aplayer_bg_music: AudioStreamPlayer2D = $aplayer_bg_music


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
    get_tree().change_scene_to_file("res://scenes/levels/level_battle.tscn")


func _on_exit_button_pressed() -> void:
    get_tree().quit()
    return
