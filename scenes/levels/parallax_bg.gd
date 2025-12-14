extends Node

class_name ParallaxBg

@export var scene_parallax_bg_layer: PackedScene


func setup(parallax_backgrounds_textures: Array[Texture2D]) -> void:
	var layer_counts: int = len(parallax_backgrounds_textures)
	if layer_counts == 0:
		return
	var id: int = 0
	for bg_texture: Texture2D in parallax_backgrounds_textures:
		append_bg_layer(id, layer_counts, bg_texture)
		id += 1
	return


func append_bg_layer(id: int, layer_counts: int, bg_texture: Texture2D) -> void:
	var parallax_bg_layer: ParallaxBgLayer = scene_parallax_bg_layer.instantiate()
	add_child(parallax_bg_layer)
	parallax_bg_layer.setup(id, bg_texture, Vector2(float(id + 1) / layer_counts, 0))
