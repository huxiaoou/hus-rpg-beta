extends CenterContainer

class_name UITurnCard

@export_group("Custom")
@export var group_flag: Unit.GroupFlag = Unit.GroupFlag.ALLY
@export var astream_hover: AudioStream
@export var astream_fades_in_out: AudioStream
@export var bg_texture_ally: Texture2D
@export var bd_texture_ally: Texture2D
@export var bg_texture_enemy: Texture2D
@export var bd_texture_enemy: Texture2D
@export var bg_texture_neutral: Texture2D
@export var bd_texture_neutral: Texture2D

@onready var bg: TextureRect = $Bg
@onready var bd: TextureRect = $Bd
@onready var av: TextureRect = $Avatar
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

const FOCUSED_RATIO: Vector2 = Vector2(1.25, 1.25)
const FADES_INOUT_RATIO: Vector2 = Vector2(1.5, 1.0)
var bg_focused_custom_min_size: Vector2
var bg_vanilla_custom_min_size: Vector2
var bd_focused_custom_min_size: Vector2
var bd_vanilla_custom_min_size: Vector2
var av_focused_custom_min_size: Vector2
var av_vanilla_custom_min_size: Vector2


func _ready() -> void:
    bg_focused_custom_min_size = bg.texture.get_size() * FOCUSED_RATIO
    bg_vanilla_custom_min_size = bg.texture.get_size()
    bd_focused_custom_min_size = bd.texture.get_size() * FOCUSED_RATIO
    bd_vanilla_custom_min_size = bd.texture.get_size()
    av_focused_custom_min_size = av.custom_minimum_size * FOCUSED_RATIO
    av_vanilla_custom_min_size = av.custom_minimum_size
    update_color()


func setup(unit: Unit) -> void:
    group_flag = unit.group_flag
    av.texture = unit.avatar
    update_color()
    return


func update_color() -> void:
    if group_flag == Unit.GroupFlag.ALLY:
        bg.texture = bg_texture_ally
        bd.texture = bd_texture_ally
    elif group_flag == Unit.GroupFlag.ENEMY:
        bg.texture = bg_texture_enemy
        bd.texture = bd_texture_enemy
    elif group_flag == Unit.GroupFlag.NEUTRAL:
        bg.texture = bg_texture_neutral
        bd.texture = bd_texture_neutral
    return


func _on_mouse_entered() -> void:
    audio_player.stream = astream_hover
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(bg, "custom_minimum_size", bg_focused_custom_min_size, 0.3)
    tw.parallel().tween_property(bd, "custom_minimum_size", bd_focused_custom_min_size, 0.3)
    tw.parallel().tween_property(av, "custom_minimum_size", av_focused_custom_min_size, 0.3)
    audio_player.play()
    await tw.finished
    return


func _on_mouse_exited() -> void:
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(bg, "custom_minimum_size", bg_vanilla_custom_min_size, 0.3)
    tw.parallel().tween_property(bd, "custom_minimum_size", bd_vanilla_custom_min_size, 0.3)
    tw.parallel().tween_property(av, "custom_minimum_size", av_vanilla_custom_min_size, 0.3)
    await tw.finished
    return


func fades_out() -> void:
    audio_player.stream = astream_fades_in_out
    audio_player.play()
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "modulate:a", 0.0, 0.5)
    await tw.finished

    bg.queue_free()
    bd.queue_free()
    av.queue_free()

    tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "custom_minimum_size:x", 0, 0.5).from(160)
    await tw.finished
    queue_free()
    return


func fades_in() -> void:
    audio_player.stream = astream_fades_in_out
    audio_player.play()
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(self, "modulate:a", 1.0, 0.5).from(0.0)
    await tw.finished
    return
