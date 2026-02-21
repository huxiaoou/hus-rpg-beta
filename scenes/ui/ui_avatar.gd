extends Control

class_name UIAvatar

## a texture with size = (136, 136) and a round portrait at the center
@export var avatar: Texture2D
@onready var ui_unit_frame: UIUnitFrame = $UIUnitFrame
@onready var ui_level: UILevel = $VBoxLevel/UILevel
@onready var ui_bar_health: UIDualProgressBar = $HBoxInfo/Bg/MarginContainer/VBoxBars/Row0/UIBarHealth
@onready var ui_bar_magicka: UIDualProgressBar = $HBoxInfo/Bg/MarginContainer/VBoxBars/Row0/UIBarMagicka
@onready var ui_bar_stamina: UIDualProgressBar = $HBoxInfo/Bg/MarginContainer/VBoxBars/Row1/UIBarStamina
@onready var ui_bar_resolve: UIDualProgressBar = $HBoxInfo/Bg/MarginContainer/VBoxBars/Row1/UIBarResolve
@onready var ui_status_attack: UIStatus = $HBoxInfo/Bg/MarginContainer/VBoxBars/HBoxStatus/UIStatusAttack
@onready var ui_status_armor: UIStatus = $HBoxInfo/Bg/MarginContainer/VBoxBars/HBoxStatus/UIStatusArmor
@onready var ui_status_initiative: UIStatus = $HBoxInfo/Bg/MarginContainer/VBoxBars/HBoxStatus/UIStatusInitiative


func _ready() -> void:
    ui_unit_frame.set_avatar(avatar)
    return


func _input(event: InputEvent) -> void:
    if event.is_action_pressed("test_add"):
        #ui_bar_health.on_value_changed(ui_bar_health.dual_pb_val + 10)
        #ui_bar_magicka.on_value_changed(ui_bar_magicka.dual_pb_val + 5)
        #ui_bar_resolve.on_value_changed(ui_bar_resolve.dual_pb_val + 3)
        # ui_level.on_exp_changed(ui_level.exp_circle.value + 20)
        pass
    elif event.is_action_pressed("test_subtract"):
        #ui_bar_health.on_value_changed(ui_bar_health.dual_pb_val - 10)
        #ui_bar_magicka.on_value_changed(ui_bar_magicka.dual_pb_val - 5)
        #ui_bar_resolve.on_value_changed(ui_bar_resolve.dual_pb_val - 3)
        # ui_level.on_exp_changed(ui_level.exp_circle.value - 20)
        pass
    return


func init_from_unit(unit: Unit) -> void:
    ui_unit_frame.set_avatar(unit.data.avatar)
    ui_bar_health.init_value(unit.data.health, unit.data.max_health, 0, 1)
    ui_bar_magicka.init_value(unit.data.magicka, unit.data.max_magicka, 0, 1)
    ui_bar_stamina.init_value(unit.data.stamina, unit.data.max_stamina, 0, 1)
    ui_bar_resolve.init_value(unit.data.resolve, unit.data.max_resolve, 0, 1)

    unit.data.health_changed.connect(ui_bar_health.on_value_changed)
    unit.data.magicka_changed.connect(ui_bar_magicka.on_value_changed)
    unit.data.stamina_changed.connect(ui_bar_stamina.on_value_changed)
    unit.data.resolve_changed.connect(ui_bar_resolve.on_value_changed)

    ui_status_attack.set_value(unit.data.attack)
    ui_status_armor.set_value(unit.data.armor)
    ui_status_initiative.set_value(unit.data.initiative)
    return
