extends HBoxContainer

class_name UITurnCardsDeck

func append(unit: Unit) -> void:
    var scene_turn_card: PackedScene = preload("res://scenes/ui/ui_turn_card.tscn")
    var turn_card: UITurnCard = scene_turn_card.instantiate()
    add_child(turn_card)
    turn_card.setup(unit)
