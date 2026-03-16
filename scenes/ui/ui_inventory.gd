extends VBoxContainer

class_name UIInventory

const GRID_COLUMNS: int = 8
const MIN_GRID_ROWS: int = 10

@onready var grid: GridContainer = $ScrollContainer/GridContainer
@onready var aplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var option_button: OptionButton = $HBoxContainer/OptionButton

var scene_inv_slot: PackedScene = preload("res://scenes/ui/ui_inventory_slot.tscn")
var rows: int = MIN_GRID_ROWS
var new_rows: int = MIN_GRID_ROWS
var unit: Unit = null


func _ready():
    grid.columns = GRID_COLUMNS
    for i: int in range(GRID_COLUMNS * MIN_GRID_ROWS):
        var slot: UIInventorySlot = scene_inv_slot.instantiate()
        grid.add_child(slot)
    ManagerInventory.inventory_updated.connect(refresh_inventory)
    ManagerInventory.set_sort_func_by_weight()

    var popup: PopupMenu = option_button.get_popup()
    popup.add_theme_font_size_override("font_size", 28)
    refresh_inventory()
    return


func refresh_inventory():
    new_rows = max(ManagerInventory.items.size() / GRID_COLUMNS + 2, MIN_GRID_ROWS)
    if new_rows > rows:
        for i: int in range((new_rows - rows) * GRID_COLUMNS):
            var slot: UIInventorySlot = scene_inv_slot.instantiate()
            grid.add_child(slot)
    elif new_rows < rows:
        for i: int in range((rows - new_rows) * GRID_COLUMNS):
            var slot: UIInventorySlot = grid.get_child(grid.get_child_count() - 1)
            slot.free()
    rows = new_rows

    var counter: int = 0
    for item: EquipableItem in ManagerInventory.items:
        var slot: UIInventorySlot = grid.get_child(counter)
        slot.display_item(item)
        counter += 1
    for i: int in range(counter, grid.get_child_count()):
        var slot: UIInventorySlot = grid.get_child(i)
        slot.display_item(null)
    return


func _on_option_button_item_selected(index: int) -> void:
    aplayer.play()
    var text: String = option_button.get_item_text(index)
    match text:
        "Value":
            ManagerInventory.set_sort_func_by_value()
        "Weight":
            ManagerInventory.set_sort_func_by_weight()
        "Power Bonus":
            ManagerInventory.set_sort_func_by_power_bonus()
        "Defense Bonus":
            ManagerInventory.set_sort_func_by_defense_bonus()
        "Name":
            ManagerInventory.set_sort_func_by_name()
    ManagerInventory.sort_items()
    return


func _unhandled_input(event: InputEvent) -> void:
    var item: EquipableItem = null
    if event.is_action_pressed("test_action_1"):
        item = load("res://resources/equipments/iron_sword.tres")
    elif event.is_action_pressed("test_action_2"):
        item = load("res://resources/equipments/leather_armor.tres")
    elif event.is_action_pressed("test_action_3"):
        item = load("res://resources/equipments/necklace.tres")
    if item != null:
        ManagerInventory.add_item(item)
    return


func set_unit(_unit:Unit) -> void:
    unit = _unit
