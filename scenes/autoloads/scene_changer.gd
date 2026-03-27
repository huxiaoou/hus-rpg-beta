extends CanvasLayer

@onready var background: TextureRect = $Background
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var is_ready: bool = false
@onready var allow_to_continue: bool = false


func _ready() -> void:
    visible = false
    label.modulate.a = 0


func fade_in() -> void:
    animation_player.play("fade_in")
    await animation_player.animation_finished
    return


func fade_out() -> void:
    animation_player.play("fade_out")
    await animation_player.animation_finished
    return


func change_scene(target_scene_path: String) -> void:
    fade_in()

    var loader: Error = ResourceLoader.load_threaded_request(target_scene_path)
    if loader != OK:
        push_error("Failed to load scene at : %s" % target_scene_path)
        return

    while true:
        var progress: Array[float] = []
        var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
        progress_bar.value = progress[0] * 100
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            animation_player.play("show_tips")
            is_ready = true
            break
        if status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
            push_error("Error during load %s" % target_scene_path)
        # await get_tree().process_frame
        await get_tree().create_timer(0.5).timeout

    await _wait_for_input()
    var new_packed_scene: PackedScene = ResourceLoader.load_threaded_get(target_scene_path)
    get_tree().change_scene_to_packed(new_packed_scene)
    fade_out()
    allow_to_continue = false
    is_ready = false
    return


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("continue") and is_ready:
        allow_to_continue = true
        get_viewport().set_input_as_handled()


func _wait_for_input():
    while true:
        await get_tree().process_frame
        if allow_to_continue:
            return
