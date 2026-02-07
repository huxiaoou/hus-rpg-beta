extends HBoxContainer

class_name UITurnCardsDeck

signal updated()

var turn_cards: Array[UITurnCard] = []
var scene_turn_card: PackedScene = preload("res://scenes/ui/ui_turn_card.tscn")


func _ready() -> void:
    ManagerTurnsAndRounds.turn_books_updated.connect(on_turn_books_updated)
    return


func append_card(unit: Unit) -> void:
    var turn_card: UITurnCard = scene_turn_card.instantiate()
    add_child(turn_card)
    turn_cards.append(turn_card)
    turn_card.setup(unit)
    await turn_card.fades_in()
    return


func on_turn_books_updated() -> void:
    var size_units: int = ManagerTurnsAndRounds.turn_books_size()
    if size_units < turn_cards.size():
        for i in range(turn_cards.size() - size_units):
            var turn_card: UITurnCard = turn_cards.pop_front()
            await turn_card.fades_out()
    var counter: int = 0
    for unit: Unit in ManagerTurnsAndRounds.turn_books():
        if counter == turn_cards.size():
            await append_card(unit)
        else:
            turn_cards[counter].setup(unit)
        counter += 1
    updated.emit()
    return
