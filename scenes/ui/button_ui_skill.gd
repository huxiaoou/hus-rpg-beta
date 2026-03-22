extends Button

class_name ButtonUISkill

@onready var skill_tex: TextureRect = $SkillTex
@onready var aplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

var default_tex: Texture2D = preload("res://assets/ui/default_skill_icon_bg.png")
# var default_tex: Texture2D = preload("res://assets/ui/skill icon 55.png")

const COLOR_FOCUS_HOVER: Color = Color.WHITE
const COLOR_FOCUS_PRESSED: Color = Color.BLACK
const COLOR_DEFAULT: Color = Color(1, 1, 1, 0)

const BORDER_WIDTH_FOCUS_HOVER: float = 0.0250
const BORDER_WIDTH_FOCUS_PRESSED: float = 0.0400
const BORDER_WIDTH_DEFAULT: float = 0.0125

var astream_hover: AudioStream = preload("res://assets/audios/Hovers A 001.wav")
var astream_click: AudioStream = preload("res://assets/audios/Clicks B 001.wav")


func _ready() -> void:
    set_default()


func set_default() -> void:
    skill_tex.texture = default_tex


func aplay_hover() -> void:
    aplayer.stream = astream_hover
    aplayer.play()


func aplay_click() -> void:
    aplayer.stream = astream_click
    aplayer.play()


func set_tex_color_pressed() -> void:
    skill_tex.material.set_shader_parameter("tint", COLOR_FOCUS_PRESSED)
    skill_tex.material.set_shader_parameter("use_gradient", true)
    skill_tex.material.set_shader_parameter("border_width", BORDER_WIDTH_FOCUS_PRESSED)


func set_tex_color_focus_hover() -> void:
    skill_tex.material.set_shader_parameter("tint", COLOR_FOCUS_HOVER)
    skill_tex.material.set_shader_parameter("use_gradient", true)
    skill_tex.material.set_shader_parameter("border_width", BORDER_WIDTH_FOCUS_HOVER)


func set_tex_color_default() -> void:
    skill_tex.material.set_shader_parameter("tint", COLOR_DEFAULT)
    skill_tex.material.set_shader_parameter("use_gradient", false)
    skill_tex.material.set_shader_parameter("border_width", BORDER_WIDTH_DEFAULT)


func _on_mouse_entered() -> void:
    set_tex_color_focus_hover()
    aplay_hover()


func _on_mouse_exited() -> void:
    set_tex_color_default()


func _on_focus_entered() -> void:
    set_tex_color_focus_hover()
    aplay_hover()


func _on_focus_exited() -> void:
    set_tex_color_default()


func _on_button_down() -> void:
    set_tex_color_pressed()


func _on_button_up() -> void:
    set_tex_color_default()


func _on_pressed() -> void:
    set_tex_color_pressed()
    aplay_click()
    await get_tree().create_timer(0.2).timeout
    set_tex_color_default()
    return
