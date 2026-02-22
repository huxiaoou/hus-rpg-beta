extends Projectile

class_name Fireball

func on_impacted(_damage: DataDamage, taker: Unit) -> void:
    animated_sprite_2d.animation = "flame"
    animated_sprite_2d.global_position = taker.global_position + Vector2(-24, -64)
    animated_sprite_2d.global_rotation = 0
    var tw: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
    tw.tween_property(animated_sprite_2d, "modulate:a", 0.0, 0.3)
    audio_stream_player_2d.play()
    await tw.finished
    impacted.emit()
    return
