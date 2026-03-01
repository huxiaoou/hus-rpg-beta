extends Projectile

class_name Arrow

func _ready() -> void:
    animated_sprite_2d.animation = "arrow"


func on_unit_damage_taken(_damage: DataDamage, _taker: Unit) -> void:
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.3)

    hit_effect.set_location(ManagerCellBattle.cell_to_point(target_cell))
    audio_stream_player_2d.play()
    await hit_effect.play()
    impacted.emit()
    return
