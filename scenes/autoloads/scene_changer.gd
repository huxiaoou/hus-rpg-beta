extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target_scene_path: String
var is_ready: bool = false


func _ready() -> void:
    visible = false


func fade_in() -> void:
    visible = true
    color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    animation_player.play("fade_in")
    await animation_player.animation_finished


func fade_out() -> void:
    animation_player.play("fade_out")
    await animation_player.animation_finished
    color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
    visible = false


func change_scene(_target_scene_path: String) -> void:
    target_scene_path = _target_scene_path
    is_ready = false
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
            is_ready = true
            break
        if status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
            push_error("Error during load %s" % target_scene_path)
        await get_tree().process_frame

    await _wait_for_input()
    var new_packed_scene: PackedScene = ResourceLoader.load_threaded_get(target_scene_path)
    get_tree().change_scene_to_packed(new_packed_scene)
    fade_out()
    return


func _wait_for_input():
    # Wait one frame to ensure previous clicks (that triggered the scene change)
    # don't accidentally trigger this too early.
    #await get_tree().process_frame

    while true:
        await get_tree().process_frame
        var event: InputEvent = await color_rect.gui_input
        if event is InputEventMouseButton:
            return
