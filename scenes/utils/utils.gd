class_name Utils

static func cal_control_point_for_bezier(start: Vector2, end: Vector2, curve_scale: float) -> Vector2:
    var mid_point = (start + end) / 2
    var direction = (end - start).normalized()
    var normal = Vector2(-direction.y, direction.x) # Perpendicular vector
    return mid_point + normal * curve_scale * start.distance_to(end) * 2
