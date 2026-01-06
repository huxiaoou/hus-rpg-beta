extends TileMapLayer

class_name LayerHexWorld

enum { TILE_MODULATE_FULL, TILE_MODULATE_TRANS }
var cur_cell: Vector2i = Vector2i(0, 0)
var new_cell: Vector2i = Vector2i(0, 0)


func _process(_delta: float) -> void:
    var mouse_global_pos: Vector2 = get_global_mouse_position()
    new_cell = point_to_cell(mouse_global_pos)
    if new_cell != cur_cell:
        update_lower_cells_alpha(cur_cell, TILE_MODULATE_FULL)
        update_lower_cells_alpha(new_cell, TILE_MODULATE_TRANS)
        cur_cell = new_cell
        print("Current cell = %s" % cur_cell)


func get_offset_left(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + Vector2i(-1, 0) * size


func get_offset_right(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + Vector2i(1, 0) * size


func get_offset_left_upper(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + (Vector2i(-1, -1) if cell.y % 2 == 0 else Vector2i(0, -1)) * size


func get_offset_left_lower(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + (Vector2i(-1, 1) if cell.y % 2 == 0 else Vector2i(0, 1)) * size


func get_offset_right_upper(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + (Vector2i(0, -1) if cell.y % 2 == 0 else Vector2i(1, -1)) * size


func get_offset_right_lower(cell: Vector2i, size: int = 1) -> Vector2i:
    return cell + (Vector2i(0, 1) if cell.y % 2 == 0 else Vector2i(1, 1)) * size


func point_to_cell(point: Vector2) -> Vector2i:
    return local_to_map(to_local(point))


func cell_to_point(cell: Vector2i) -> Vector2:
    return to_global(map_to_local(cell))


func update_lower_cells_alpha(cell: Vector2i, alternative: int) -> void:
    set_cell_alpha(get_offset_left_lower(cell), alternative)
    set_cell_alpha(get_offset_right_lower(cell), alternative)
    return


func set_cell_alpha(cell: Vector2i, alternative: int) -> void:
    var data: TileData = self.get_cell_tile_data(cell)
    if data:
        if data.get_custom_data("cross_hex"):
            set_cell(cell, get_cell_source_id(cell), get_cell_atlas_coords(cell), alternative)
    return
