extends Node

signal turn_books_updated()
signal active_unit_changed(unit: Unit)
signal event_appended()

var active_unit: Unit:
    get:
        return null if this_turn_book.is_empty() else this_turn_book[0]

var registered_units: Dictionary[int, Unit] = { }
var this_turn_book: Array[Unit] = []
var next_turn_book: Array[Unit] = []
var events_queue: Array[DataEventTurn] = []

var ui_turn_cards_deck: UITurnCardsDeck


func setup(units: Array[Unit], _turn_cards_deck: UITurnCardsDeck) -> void:
    ui_turn_cards_deck = _turn_cards_deck
    for unit in units:
        register_unit(unit)
    sort_turn_books()
    turn_books_updated.emit()
    await ui_turn_cards_deck.updated
    if not this_turn_book.is_empty():
        active_unit.unit_turn_finished.connect(on_unit_turn_finished)
        active_unit_changed.emit(active_unit)
    main_loop()
    return


func register_unit(unit: Unit) -> void:
    registered_units[unit.get_instance_id()] = unit
    this_turn_book.append(unit)
    next_turn_book.append(unit)
    unit.died.connect(on_unit_died)
    return


func sort_turn_books() -> void:
    this_turn_book.sort_custom(Unit.sort_by_initiative)
    next_turn_book.sort_custom(Unit.sort_by_initiative)
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


func refresh_turnbook() -> void:
    this_turn_book = next_turn_book
    next_turn_book = registered_units.values()
    return


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


func try_create_new_round() -> void:
    if this_turn_book.is_empty():
        refresh_turnbook()
        sort_turn_books()
        turn_books_updated.emit()
        await ui_turn_cards_deck.updated
    return


func process_unit_turn_finished(unit: Unit) -> void:
    if unit != active_unit:
        print("[WRN] wrong unit finishes turn")
        return
    active_unit.unit_turn_finished.disconnect(on_unit_turn_finished)
    print("Unit %s's turn ends." % active_unit.name)
    this_turn_book.pop_front()
    turn_books_updated.emit()
    await ui_turn_cards_deck.updated
    await try_create_new_round()
    active_unit.unit_turn_finished.connect(on_unit_turn_finished)
    print("Unit %s' turn begins." % active_unit.name)
    active_unit_changed.emit(active_unit)
    return


func process_unit_died(unit: Unit) -> void:
    unit.died.disconnect(on_unit_died)
    registered_units.erase(unit.get_instance_id())
    if unit != active_unit:
        this_turn_book.erase(unit)
    next_turn_book.erase(unit)
    turn_books_updated.emit()
    await ui_turn_cards_deck.updated
    unit.clear()
    return


func turn_books_size() -> int:
    return this_turn_book.size() + next_turn_book.size()


func turn_books() -> Array[Unit]:
    return this_turn_book + next_turn_book


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
    print_turn_book(this_turn_book, "THIS")
    return


func print_next_turn_book() -> void:
    print_turn_book(next_turn_book, "NEXT")
    return


func print_status() -> void:
    print("\nManagerTurnsAndRoundsStatus")
    print_active_unit()
    print_this_turn_book()
    print_next_turn_book()
    return
