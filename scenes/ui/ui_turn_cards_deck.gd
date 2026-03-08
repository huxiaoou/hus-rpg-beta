extends HBoxContainer

class_name UITurnCardsDeck

signal updated()

@onready var queue_curr_round_cards: HBoxContainer = $QueueCurrRoundCards
@onready var queue_next_round_cards: HBoxContainer = $QueueNextRoundCards

var scene_turn_card: PackedScene = preload("res://scenes/ui/ui_turn_card.tscn")


func _ready() -> void:
    ManagerTurnsAndRounds.turn_books_updated.connect(on_turn_books_updated)
    ManagerTurnsAndRounds.curr_round_appended.connect(curr_queue_append_card)
    ManagerTurnsAndRounds.next_round_appended.connect(next_queue_append_card)
    ManagerTurnsAndRounds.curr_round_pop_front.connect(curr_queue_pop_front_card)
    ManagerTurnsAndRounds.next_round_pop_front.connect(next_queue_pop_front_card)
    ManagerTurnsAndRounds.next_round_entered.connect(on_next_round_entered)
    return


# --- append cards to queues ---
func queue_append_card(unit: Unit, queue: HBoxContainer) -> void:
    var turn_card: UITurnCard = scene_turn_card.instantiate()
    queue.add_child(turn_card)
    turn_card.setup(unit)
    await turn_card.fades_in()
    updated.emit()
    return


func curr_queue_append_card(unit: Unit) -> void:
    queue_append_card(unit, queue_curr_round_cards)
    return


func next_queue_append_card(unit: Unit) -> void:
    queue_append_card(unit, queue_next_round_cards)
    return


# --- pop cards front from queues ---
func queue_pop_front_card(queue: HBoxContainer) -> void:
    var turn_card: UITurnCard = queue.get_child(0)
    await turn_card.fades_out()
    updated.emit()
    return


func curr_queue_pop_front_card() -> void:
    queue_pop_front_card(queue_curr_round_cards)
    return


func next_queue_pop_front_card() -> void:
    queue_pop_front_card(queue_next_round_cards)
    return


# --- on next round entered ---
func on_next_round_entered() -> void:
    var turn_cards: Array = queue_next_round_cards.get_children()
    for turn_card in turn_cards:
        queue_next_round_cards.remove_child(turn_card)
        queue_curr_round_cards.add_child(turn_card)
    updated.emit()
    return


func on_turn_books_updated() -> void:
    # var size_units: int = ManagerTurnsAndRounds.turn_books_size()
    # if size_units < turn_cards.size():
    #     for i in range(turn_cards.size() - size_units):
    #         var turn_card: UITurnCard = turn_cards.pop_front()
    #         await turn_card.fades_out()
    # var counter: int = 0
    # for unit: Unit in ManagerTurnsAndRounds.turn_books():
    #     if counter == turn_cards.size():
    #         await append_card(unit)
    #     else:
    #         turn_cards[counter].setup(unit)
    #     counter += 1
    #     if counter == ManagerTurnsAndRounds.curr_round_book.size():
    #         call_deferred("move_child", ui_round_sep, counter)
    #         await get_tree().create_timer(0.5).timeout
    # updated.emit()
    return
