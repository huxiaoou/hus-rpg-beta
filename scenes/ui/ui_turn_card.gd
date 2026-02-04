extends CenterContainer

class_name UITurnCard

@export_group("Custom")
@export var group_flag: Unit.GroupFlag
@export var astream_hover: AudioStream
@export var astream_fades_in_out: AudioStream

@onready var avatar: TextureRect = $MarginContainer/Avatar
@onready var neutral: CenterContainer = $Neutral
@onready var enemy: CenterContainer = $Enemy
@onready var ally: CenterContainer = $Ally
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

const FOCUSED_RATIO: Vector2 = Vector2(1.0, 1.5)
const FADES_INOUT_RATIO: Vector2 = Vector2(1.5, 1.0)
var focused_custom_min_size: Vector2
var fades_inout_custom_min_size: Vector2
var vanilla_custom_min_size: Vector2


func _ready() -> void:
    focused_custom_min_size = custom_minimum_size * FOCUSED_RATIO
    fades_inout_custom_min_size = custom_minimum_size * FADES_INOUT_RATIO
    vanilla_custom_min_size = custom_minimum_size


func setup(unit: Unit) -> void:
    group_flag = unit.group_flag
    avatar.texture = unit.avatar
    update_color()
    return


func update_color() -> void:
    if group_flag == Unit.GroupFlag.ALLY:
        set_ally_visibility(true)
        set_enemy_visibility(false)
        set_neutral_visibility(false)
    elif group_flag == Unit.GroupFlag.ENEMY:
        set_ally_visibility(false)
        set_enemy_visibility(true)
        set_neutral_visibility(false)
    elif group_flag == Unit.GroupFlag.NEUTRAL:
        set_ally_visibility(false)
        set_enemy_visibility(false)
        set_neutral_visibility(true)
    return


func set_ally_visibility(visibility: bool) -> void:
    ally.visible = visibility
    return


func set_enemy_visibility(visibility: bool) -> void:
    enemy.visible = visibility
    return


func set_neutral_visibility(visibility: bool) -> void:
    neutral.visible = visibility
    return


func _on_mouse_entered() -> void:
    audio_player.stream = astream_hover
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "custom_minimum_size", focused_custom_min_size, 0.3)
    audio_player.play()
    await tw.finished
    return


func _on_mouse_exited() -> void:
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "custom_minimum_size", vanilla_custom_min_size, 0.3)
    await tw.finished
    return


func fades_out() -> void:
    audio_player.stream = astream_fades_in_out
    audio_player.play()
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "modulate:a", 0.0, 1.0)
    tw.parallel().tween_property(self, "custom_minimum_size", fades_inout_custom_min_size, 0.5)
    await tw.finished
    queue_free()
    return


func fades_in() -> void:
    audio_player.stream = astream_fades_in_out
    audio_player.play()
    modulate.a = 0.0
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "modulate:a", 1.0, 1.0)
    await tw.finished
    return
