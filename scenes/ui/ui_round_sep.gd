extends CenterContainer

class_name UIRoundSep

@export var round_id: String

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
    label.text = round_id
    
