extends Node

class_name Ability

@export_group("General")
@export var short_name: String
@export var id: String
@export var description: String
@export var icon: Texture2D
@export var key_binding: String

@export_group("Cost")
@export var cost_health: int = 0
@export var cost_stamnia: int = 33
@export var cost_magicka: int = 0
@export var cost_resolve: int = 0

@export_group("Range")
@export var ability_range: int = 1

@onready var asm: AbilityStatesMachine = $AbilityStatesMachine
@onready var audio_player: AudioPlayerForAbility = $AudioPlayerForAbility

var owner_unit: Unit = null
var is_active: bool = false
var is_casting: bool = false

var max_num_target_cells: int = 16
var max_num_target_units: int = 16
var target_cells: Array[Vector2i] = []
var target_cell: Vector2i:
    get:
        return Vector2i.ZERO if target_cells.is_empty() else target_cells[0]
var target_units: Array[Unit] = []
var target_unit: Unit:
    get:
        return null if target_units.is_empty() else target_units[0]
var data_ai_ability: DataAiAbility = DataAiAbility.new()

var available_cells: Array[Vector2i] = []
var potential_target_cell: Vector2i
var potential_target_cell_new: Vector2i

const SCORE_BASIC: int = 10
const SCORE_PER_UNIT_HIT_AOE: int = 12
const SCORE_SINGLE_UNIT_RANGED: int = 15
const SCORE_SINGLE_UNIT_MELEE: int = 20

signal activated(Ability)
signal deactivated(Ability)
signal casting_finished()


# ---- Setup ----
func _ready() -> void:
    asm.setup(self)
    return


func call_ai_to_cast() -> void:
    asm.on_change_state(AbilityState.State.AIMING)
    return


func setup(_owner_unit: Unit, _connect: Callable) -> void:
    owner_unit = _owner_unit
    is_active = false
    is_casting = false
    _connect.call(self)
    return


func is_selected() -> bool:
    return owner_unit.mgr_abilities.selected_ability == self


# --- Available cells management ----
func update_available_cells() -> void:
    available_cells = ManagerCellBattle.get_cells_in_range(owner_unit.cell, ability_range)
    return


func recolor_available_cells() -> void:
    for avlb_cell: Vector2i in available_cells:
        ManagerCellBattle.set_cell_potential(avlb_cell)
    return


func clear_available_cells() -> void:
    for cell: Vector2i in available_cells:
        ManagerCellBattle.set_cell_vanilla(cell)
    available_cells.clear()
    return


# --- Cost check ----
func check_health_cost() -> bool:
    if owner_unit.data.health < cost_health:
        audio_player.play_warning()
        print("Not enough health, %d/%d" % [owner_unit.data.health, cost_health])
        return false
    return true


func check_stamina_cost() -> bool:
    if owner_unit.data.stamina < cost_stamnia:
        audio_player.play_warning()
        print("Not enough stamina, %d/%d" % [owner_unit.data.stamina, cost_stamnia])
        return false
    return true


func check_magicka_cost() -> bool:
    if owner_unit.data.magicka < cost_magicka:
        audio_player.play_warning()
        print("Not enough magicka, %d/%d" % [owner_unit.data.magicka, cost_magicka])
        return false
    return true


func check_resolve_cost() -> bool:
    if owner_unit.data.resolve < cost_resolve:
        audio_player.play_warning()
        print("Not enough resolve, %d/%d" % [owner_unit.data.resolve, cost_resolve])
        return false
    return true


func check_ability_cost() -> bool:
    return check_health_cost() and check_stamina_cost() and check_magicka_cost() and check_resolve_cost()


# ---- Ability State logic ----
func activate() -> void:
    audio_player.play_selected()
    is_active = true
    update_available_cells()
    recolor_available_cells()
    potential_target_cell = available_cells[0]
    ManagerCellBattle.set_cell_focused(potential_target_cell)
    print("%s activates Ability %s " % [owner_unit.name, short_name])
    activated.emit(self)
    return


func try_launch() -> bool:
    if is_casting:
        audio_player.play_warning()
        print("%s is casting ability %s" % [owner_unit.name, short_name])
        return false
    if check_ability_cost():
        owner_unit.data.change_stamina(-cost_stamnia)
        owner_unit.data.change_magicka(-cost_magicka)
        owner_unit.data.change_resolve(-cost_resolve)
        owner_unit.data.change_health(-cost_health)
        return true
    return false


func launch() -> void:
    is_casting = true
    print("%s launches ability %s" % [owner_unit.name, short_name])
    audio_player.play_selected()
    return


func finish() -> void:
    casting_finished.emit()
    return


func deactivate() -> void:
    is_casting = false
    is_active = false
    target_cells.clear()
    target_units.clear()
    clear_available_cells()
    if owner_unit:
        ManagerCellBattle.set_cell_vanilla(owner_unit.cell)
        print("%s deactivate ability %s" % [owner_unit.name, short_name])
    deactivated.emit(self)
    return


func process_aiming(_delta: float) -> void:
    pass


func process_casting(_delta: float) -> void:
    pass


func is_valid(_cell: Vector2i) -> bool:
    return true


func add_target(new_target_cell: Vector2i) -> bool:
    if target_cells.size() < max_num_target_cells:
        if is_valid(new_target_cell):
            target_cells.append(new_target_cell)
            ManagerCellBattle.set_cell_target(new_target_cell)
            audio_player.play_selected()
            print("Cell %s is add to target cells" % new_target_cell)
        else:
            audio_player.play_warning()
            print("Cell %s is invaild" % new_target_cell)
        return true
    # target_cells.size() >= max_num_target_cells:
    return false


func remove_target() -> bool:
    if target_cells.size() > 0:
        if is_casting:
            audio_player.play_warning()
            print("Ability %s is casting, can not cancel target" % short_name)
        else:
            var old_target_cell: Vector2i = target_cells.pop_back()
            ManagerCellBattle.set_cell_vanilla(old_target_cell)
            audio_player.play_canceled()
            print("Cell %s is dropped out from target cells" % old_target_cell)
        return true
    # target_cells.size() == 0
    audio_player.play_canceled()
    return false


# --- AI logic ---
func think() -> DataAiAbility:
    data_ai_ability.reset()
    if check_ability_cost():
        data_ai_ability.score = 0
    return data_ai_ability


func score_gt_zero() -> bool:
    return data_ai_ability.score > 0


func is_better_than(other: Ability) -> bool:
    return data_ai_ability.score > other.data_ai_ability.score
