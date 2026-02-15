extends Resource

class_name DataDamage

enum EDmgType {
    PHYSICS,
    MAGIC,
}

var caster: Unit = null
var amount: float = 0
var dmg_type: EDmgType = EDmgType.PHYSICS


func _to_string() -> String:
    return "Caster: %s, Damage: %f, Type: %s" % [caster.name, amount, str(dmg_type)]
