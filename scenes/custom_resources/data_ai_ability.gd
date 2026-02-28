extends Resource

class_name DataAiAbility

var targets: Array[Vector2i] = []
var score: int = -1


func _to_string() -> String:
    return "Targets: %s, Score: %d" % [str(targets), score]
