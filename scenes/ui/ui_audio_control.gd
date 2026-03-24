extends HBoxContainer

class_name UIAudioControl

@export var bus_name: String = "Master"

@onready var h_slider: HSlider = $HSlider
@onready var label: Label = $BG/Label

var bus_index: int


func _ready() -> void:
    label.text = bus_name
    bus_index = AudioServer.get_bus_index(bus_name)
    h_slider.value = AudioServer.get_bus_volume_linear(bus_index)
    print("UIAudioControl ready for bus '%s' (index %d)" % [bus_name, bus_index])
    print("Current volume: %f" % h_slider.value)
    return


func _on_h_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_linear(bus_index, value)
    print("Volume for bus '%s' (index %d) set to %f" % [bus_name, bus_index, value])
    return
