extends HBoxContainer

class_name UITurnCardsDeck

@onready var queue_curr_round_cards: HBoxContainer = $QueueCurrRoundCards
@onready var queue_next_round_cards: HBoxContainer = $QueueNextRoundCards

var scene_turn_card: PackedScene = preload("res://scenes/ui/ui_turn_card.tscn")


# --- append cards to queues ---
func queue_append_card(unit: Unit, queue: HBoxContainer) -> void:
    var turn_card: UITurnCard = scene_turn_card.instantiate()
    queue.add_child(turn_card)
    turn_card.setup(unit)
    await turn_card.fades_in()
    return


func curr_queue_append_card(unit: Unit) -> void:
    await queue_append_card(unit, queue_curr_round_cards)
    return


func next_queue_append_card(unit: Unit) -> void:
    await queue_append_card(unit, queue_next_round_cards)
    return


# --- pop cards front from queues ---
func queue_pop_front_card(queue: HBoxContainer) -> void:
    var turn_card: UITurnCard = queue.get_child(0)
    await turn_card.fades_out()
    return


func curr_queue_pop_front_card() -> void:
    await queue_pop_front_card(queue_curr_round_cards)
    return


func next_queue_pop_front_card() -> void:
    await queue_pop_front_card(queue_next_round_cards)
    return


# --- erase cards of unit from queues ---
func queue_erase_unit_card(unit: Unit, queue: HBoxContainer) -> void:
    for turn_card: UITurnCard in queue.get_children():
        if turn_card.unit == unit:
            await turn_card.fades_out()
            break
    return


func curr_queue_erase_unit_card(unit: Unit) -> void:
    await queue_erase_unit_card(unit, queue_curr_round_cards)
    return


func next_queue_erase_unit_card(unit: Unit) -> void:
    await queue_erase_unit_card(unit, queue_next_round_cards)
    return


# --- on next round entered ---
func on_next_round_entered() -> void:
    var turn_cards: Array = queue_next_round_cards.get_children()
    for turn_card in turn_cards:
        queue_next_round_cards.remove_child(turn_card)
        queue_curr_round_cards.add_child(turn_card)
    return
