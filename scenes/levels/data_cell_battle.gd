class_name DataCellBattle

var walkable: bool = true
var occupiant: Unit = null
var is_occupied: bool:
    get:
        return occupiant != null
var is_reachable: bool:
    get:
        return walkable and !is_occupied
