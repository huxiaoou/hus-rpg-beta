class_name DataCellBattle

var walkable: bool = true
var occupiant: Unit = null
var is_occupied: bool:
	get:
		return occupiant != null
	set(value):
		is_occupied = value
