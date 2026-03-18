extends Node

signal active_unit_changed(unit: Unit)
signal event_appended()
signal units_registered()
signal ally_died(unit: Unit)

var registered_units: Dictionary[int, Unit] = { }
var curr_round_book: Array[Unit] = []
var next_round_book: Array[Unit] = []
var events_queue: Array[DataEventTurn] = []
var ui_turn_cards_deck: UITurnCardsDeck
var active_unit: Unit:
    get:
        return null if curr_round_book.is_empty() else curr_round_book[0]


func register_unit(unit: Unit) -> void:
    registered_units[unit.get_instance_id()] = unit
    unit.died.connect(on_unit_died)
    return


func regiestered_allies() -> Array[Unit]:
    var allies: Array[Unit] = []
    for unit: Unit in registered_units.values():
        if unit.is_ally():
            allies.append(unit)
    return allies


func find_next_ally(curr_ally: Unit, shift: int = 1) -> Unit:
    var allies: Array[Unit] = regiestered_allies()
    var i: int = allies.find(curr_ally)
    var next: int = (i + shift) % allies.size()
    return allies[next]


func setup(units: Array[Unit], _turn_cards_deck: UITurnCardsDeck) -> void:
    ui_turn_cards_deck = _turn_cards_deck
    for unit in units:
        register_unit(unit)
    units_registered.emit()

    var sorted_units: Array[Unit] = registered_units.values()
    sorted_units.sort_custom(Unit.sort_by_initiative)
    for unit in sorted_units:
        append_unit_to_curr_round_book(unit)

    if not curr_round_book.is_empty():
        active_unit.unit_turn_finished.connect(on_unit_turn_finished)
        active_unit_changed.emit(active_unit)
    main_loop()
    return


func append_unit_to_curr_round_book(unit: Unit) -> void:
    curr_round_book.append(unit)
    await ui_turn_cards_deck.curr_queue_append_card(unit)
    return


func append_unit_to_next_round_book(unit: Unit) -> void:
    next_round_book.append(unit)
    await ui_turn_cards_deck.next_queue_append_card(unit)
    return


func pop_front_unit_from_curr_round_book() -> Unit:
    var unit: Unit = curr_round_book.pop_front()
    await ui_turn_cards_deck.curr_queue_pop_front_card()
    return unit


func pop_front_unit_from_next_round_book() -> Unit:
    var unit: Unit = next_round_book.pop_front()
    await ui_turn_cards_deck.next_queue_pop_front_card()
    return unit


func erase_unit_from_curr_round_book(unit: Unit) -> void:
    curr_round_book.erase(unit)
    await ui_turn_cards_deck.curr_queue_erase_unit_card(unit)
    return


func erase_unit_from_next_round_book(unit: Unit) -> void:
    next_round_book.erase(unit)
    await ui_turn_cards_deck.next_queue_erase_unit_card(unit)
    return


func main_loop() -> void:
    while true:
        if events_queue.size() == 0:
            await event_appended
        var event: DataEventTurn = events_queue.pop_front()
        match event.event_type:
            DataEventTurn.EventType.TURN_FINISHED:
                await process_unit_turn_finished(event.unit)
            DataEventTurn.EventType.DIED:
                await process_unit_died(event.unit)
    return


func is_active(unit: Unit) -> bool:
    return active_unit == unit


func on_unit_turn_finished(unit: Unit) -> void:
    var event: DataEventTurn = DataEventTurn.new()
    event.unit = unit
    event.event_type = DataEventTurn.EventType.TURN_FINISHED
    events_queue.append(event)
    event_appended.emit()
    return


func on_unit_died(unit: Unit) -> void:
    var event: DataEventTurn = DataEventTurn.new()
    event.unit = unit
    event.event_type = DataEventTurn.EventType.DIED
    events_queue.append(event)
    event_appended.emit()
    return


func enter_next_round() -> void:
    curr_round_book = next_round_book.duplicate()
    next_round_book.clear()
    ui_turn_cards_deck.on_next_round_entered()
    return


func try_enter_next_round() -> void:
    if curr_round_book.is_empty():
        enter_next_round()
    return


func process_unit_turn_finished(unit: Unit) -> void:
    if unit != active_unit:
        print("[WRN] Wrong unit finishes turn")
        return
    active_unit.unit_turn_finished.disconnect(on_unit_turn_finished)
    print("Unit %s's turn ends." % active_unit.name)
    await pop_front_unit_from_curr_round_book()
    await append_unit_to_next_round_book(unit)
    try_enter_next_round()
    active_unit.unit_turn_finished.connect(on_unit_turn_finished)
    print("Unit %s' turn begins." % active_unit.name)
    active_unit_changed.emit(active_unit)
    return


func process_unit_died(unit: Unit) -> void:
    unit.died.disconnect(on_unit_died)
    registered_units.erase(unit.get_instance_id())
    if unit.is_ally():
        ally_died.emit(unit)
    if unit == active_unit:
        print("[WRN] Active unit %s died." % active_unit.name)
    await erase_unit_from_curr_round_book(unit)
    await erase_unit_from_next_round_book(unit)
    unit.clear()
    return


func turn_books_size() -> int:
    return curr_round_book.size() + next_round_book.size()


func turn_books() -> Array[Unit]:
    return curr_round_book + next_round_book


# --- Auxiliary functions for debugging ---
func print_active_unit() -> void:
    print("---")
    print("Active unit is %s" % active_unit.name)
    return


static func print_turn_book(turn_book: Array[Unit], book_name: String) -> void:
    print("---")
    print("%d units in TurnBook %s" % [turn_book.size(), book_name])
    for unit in turn_book:
        print("%s" % unit.data.name)
    return


func print_this_turn_book() -> void:
    print_turn_book(curr_round_book, "THIS")
    return


func print_next_turn_book() -> void:
    print_turn_book(next_round_book, "NEXT")
    return


func print_status() -> void:
    print("\nManagerTurnsAndRoundsStatus")
    print_active_unit()
    print_this_turn_book()
    print_next_turn_book()
    return
