extends CanvasLayer

signal message_appended()
signal available_ui_appended()

var queue_messages: Array[String] = []
var scene_message: PackedScene = preload("res://scenes/ui/ui_message.tscn")

var queue_displayed_ui: Array[UIMessage] = []
var queue_available_ui: Array[UIMessage] = []

const DISPLAYED_UI_SIZE: int = 3
const TOTAL_UI_SIZE: int = DISPLAYED_UI_SIZE + 1
const SEP: float = 4

var msg_counter: int = 0
var test_model: bool = false


func _ready() -> void:
    for i: int in range(TOTAL_UI_SIZE):
        var ui_message: UIMessage = scene_message.instantiate()
        add_child(ui_message)
        ui_message.init(i, SEP)
        ui_message.fade_out_finished.connect(on_ui_fade_out)
        queue_available_ui.append(ui_message)
    main_loop()


func on_ui_fade_out(ui: UIMessage) -> void:
    queue_displayed_ui.erase(ui)
    queue_available_ui.append(ui)
    available_ui_appended.emit()
    return


func main_loop() -> void:
    while true:
        if queue_messages.is_empty():
            await message_appended
        if queue_available_ui.is_empty():
            await available_ui_appended

        var message: String = queue_messages.pop_front()
        var ui: UIMessage = queue_available_ui.pop_front()
        ui.setup(message)
        if queue_displayed_ui.size() == 0:
            ui.position.y = get_viewport().size.y / 2 - ui.size.y - SEP
        else:
            var last_ui: UIMessage = queue_displayed_ui[-1]
            ui.position.y = last_ui.position.y + last_ui.size.y + SEP
        ui.fade_in()
        queue_displayed_ui.append(ui)
        await shift_displayed_ui()
    return


func shift_displayed_ui() -> void:
    var tween: Tween = create_tween()
    tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    for ui: UIMessage in queue_displayed_ui:
        tween.parallel().tween_property(ui, "position:y", ui.position.y - ui.size.y - SEP, 0.5)
    await tween.finished
    return


func append_message(msg: String) -> void:
    queue_messages.append(msg)
    message_appended.emit()
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_test"):
        test_model = !test_model
        append_message("Test model: %s" % ["ON" if test_model else "OFF"])
        return
    if test_model and event.is_action_pressed("test_add"):
        append_message("This is a test message %d" % msg_counter)
        msg_counter += 1
    return
