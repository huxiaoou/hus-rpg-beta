extends Button

class_name ButtonUISkill

@onready var skill_tex: TextureRect = $SkillTex

var color_focus_hover: Color = Color.WHITE
var color_focus_pressed: Color = Color.CYAN
var color_default: Color = Color(1, 1, 1, 0)


func set_tex_color_pressed() -> void:
    skill_tex.material.set_shader_parameter("tint", color_focus_pressed)
    skill_tex.material.set_shader_parameter("tint_wgt", 0.5)


func set_tex_color_focus_hover() -> void:
    skill_tex.material.set_shader_parameter("tint", color_focus_hover)
    skill_tex.material.set_shader_parameter("tint_wgt", 0.5)


func set_tex_color_default() -> void:
    skill_tex.material.set_shader_parameter("tint", color_default)
    skill_tex.material.set_shader_parameter("tint_wgt", 0.0)


func _on_mouse_entered() -> void:
    set_tex_color_focus_hover()


func _on_mouse_exited() -> void:
    set_tex_color_default()


func _on_focus_entered() -> void:
    set_tex_color_focus_hover()


func _on_focus_exited() -> void:
    set_tex_color_default()


func _on_button_down() -> void:
    set_tex_color_pressed()


func _on_button_up() -> void:
    set_tex_color_default()


func _on_pressed() -> void:
    set_tex_color_pressed()
    await get_tree().create_timer(0.2).timeout
    set_tex_color_default()
    return
