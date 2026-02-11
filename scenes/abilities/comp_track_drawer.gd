extends Node2D

class_name CompTrackDrawer

var p0: Vector2
var p1: Vector2
var p2: Vector2
var points: PackedVector2Array = PackedVector2Array()


func setup(start: Vector2, control: Vector2, end: Vector2) -> void:
    points.clear()
    p0 = start
    p1 = control
    p2 = end
    var steps: int = 20
    for i: int in range(steps + 1):
        var t: float = i / float(steps)
        var q0: Vector2 = p0.lerp(p1, t)
        var q1: Vector2 = p1.lerp(p2, t)
        var res: Vector2 = q0.lerp(q1, t)
        points.append(res - global_position) # Draw relative to node
    return


func clear() -> void:
    points.clear()
    return


func _draw():
    if points.size() > 1:
        draw_polyline(points, Color.ORANGE, 2.0)


func _process(_delta: float) -> void:
    queue_redraw()
