extends Node

signal event_appended()

var camera: Camera2D = null
var queue_event_camera_change: Array[EventCameraChange] = []
var init_status: CameraStatus = CameraStatus.new()

const DEFAULT_ZOOM_SCALE: float = 1.05
const DEFAULT_ZOOM: Vector2 = Vector2.ONE * DEFAULT_ZOOM_SCALE
const DEFAULT_DURATION: float = 1.0

var hlim: Vector2 = Vector2(960 / DEFAULT_ZOOM_SCALE, 1920 - 960 / DEFAULT_ZOOM_SCALE)
var vlim: Vector2 = Vector2(540 / DEFAULT_ZOOM_SCALE, 1080 - 540 / DEFAULT_ZOOM_SCALE)

func setup(new_camera: Camera2D) -> void:
    camera = new_camera
    if camera != null:
        camera.make_current()
        init_status.global_position = camera.global_position
        init_status.zoom = camera.zoom
    main_loop()
    return


func main_loop() -> void:
    while true:
        if queue_event_camera_change.is_empty():
            await event_appended
        var event: EventCameraChange = queue_event_camera_change.pop_front()
        await process_event(event)
    return


func process_event(event: EventCameraChange) -> void:
    var tw: Tween = create_tween()
    tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tw.tween_property(camera, "global_position", event.status.global_position, event.duration)
    tw.parallel().tween_property(camera, "zoom", event.status.zoom, event.duration)
    await tw.finished
    return


func append_event(event: EventCameraChange) -> void:
    queue_event_camera_change.append(event)
    event_appended.emit()
    return


func reset_to_init_status(_duration: float = DEFAULT_DURATION) -> void:
    var event: EventCameraChange = EventCameraChange.new()
    event.status = init_status
    event.duration = _duration
    append_event(event)
    return


func move_to(_global_position: Vector2, _zoom: Vector2 = DEFAULT_ZOOM, _duration: float = DEFAULT_DURATION) -> void:
    var event: EventCameraChange = EventCameraChange.new()
    event.status = CameraStatus.new()
    _global_position.x = clamp(_global_position.x, hlim.x, hlim.y)
    _global_position.y = clamp(_global_position.y, vlim.x, vlim.y)
    event.status.global_position = _global_position
    event.status.zoom = _zoom
    event.duration = _duration
    append_event(event)
    return


class CameraStatus extends RefCounted:
    var zoom: Vector2
    var global_position: Vector2


class EventCameraChange extends RefCounted:
    var status: CameraStatus
    var duration: float
