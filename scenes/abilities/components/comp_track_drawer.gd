extends Line2D

class_name CompTrackDrawer

var p0: Vector2
var p1: Vector2
var p2: Vector2


func update_points(start: Vector2, control: Vector2, end: Vector2) -> void:
    clear_points()
    p0 = start
    p1 = control
    p2 = end
    var steps: int = 20
    for i: int in range(steps + 1):
        var t: float = float(i) / float(steps)
        var q0: Vector2 = p0.lerp(p1, t)
        var q1: Vector2 = p1.lerp(p2, t)
        var res: Vector2 = q0.lerp(q1, t)
        add_point(to_local(res))
    return
