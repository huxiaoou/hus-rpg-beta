extends HBoxContainer

class_name UITurnCardsDeck

var turn_cards: Array[UITurnCard] = []
var scene_turn_card: PackedScene = preload("res://scenes/ui/ui_turn_card.tscn")


func _ready() -> void:
    ManagerTurnsAndRounds.turn_books_updated.connect(on_turn_books_updated)
    return


func on_turn_books_updated() -> void:
    var size_units: int = ManagerTurnsAndRounds.turn_books_size()
    if size_units < turn_cards.size():
        for i in range(turn_cards.size() - size_units):
            var turn_card: UITurnCard = turn_cards.pop_front()
            turn_card.fades_out()
    elif size_units > turn_cards.size():
        for i in range(size_units - turn_cards.size()):
            await get_tree().create_timer(0.5).timeout
            var turn_card: UITurnCard = scene_turn_card.instantiate()
            add_child(turn_card)
            turn_card.fades_in()
            turn_cards.append(turn_card)

    var counter: int = 0
    for unit: Unit in ManagerTurnsAndRounds.this_turn_book:
        turn_cards[counter].setup(unit)
        counter += 1
    for unit: Unit in ManagerTurnsAndRounds.next_turn_book:
        turn_cards[counter].setup(unit)
        counter += 1
    return
