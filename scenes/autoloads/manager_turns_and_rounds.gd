extends Node

signal turn_books_sorted()
signal active_unit_changed()

var active_unit: Unit:
    get:
        return null if this_turn_book.is_empty() else this_turn_book[0]

var registered_units: Dictionary[int, Unit] = { }
var this_turn_book: Array[Unit] = []
var next_turn_book: Array[Unit] = []


func setup(units: Array[Unit]) -> void:
    for unit in units:
        register_unit(unit)
    sort_turn_books()
    if not this_turn_book.is_empty():
        active_unit.unit_turn_finished.connect(on_unit_turn_finished)
        active_unit_changed.emit()
    return


func register_unit(unit: Unit) -> void:
    registered_units[unit.get_instance_id()] = unit
    this_turn_book.append(unit)
    next_turn_book.append(unit)
    return


func sort_turn_books() -> void:
    this_turn_book.sort_custom(Unit.sort_by_initiative)
    next_turn_book.sort_custom(Unit.sort_by_initiative)
    turn_books_sorted.emit()
    return


func print_active_unit() -> void:
    print("---")
    print("Active unit is %s" % active_unit.name)
    return


static func print_turn_book(turn_book: Array[Unit], book_name: String) -> void:
    print("---")
    print("%d units in TurnBook %s" % [turn_book.size(), book_name])
    for unit in turn_book:
        print("%s" % unit.name)
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


func is_active(unit: Unit) -> bool:
    return active_unit == unit


func refresh_turnbook() -> void:
    this_turn_book = next_turn_book
    next_turn_book = []
    for unit in registered_units.values():
        next_turn_book.append(unit)
    sort_turn_books()
    return


func on_unit_turn_finished(unit: Unit) -> void:
    if unit != active_unit:
        print("[WRN] wrong unit finishes turn")
        return
    active_unit.unit_turn_finished.disconnect(on_unit_turn_finished)
    print("Unit %s's turn ends." % active_unit.name)
    this_turn_book.pop_front()
    if this_turn_book.is_empty():
        refresh_turnbook()
    active_unit.unit_turn_finished.connect(on_unit_turn_finished)
    active_unit_changed.emit()
    # print_status()
    print("Unit %s' turn begins." % active_unit.name)
    return
