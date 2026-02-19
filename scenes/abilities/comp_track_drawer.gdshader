shader_type canvas_item;

uniform float speed = 2.0;

void fragment() {
    vec2 shifted_uv = UV - vec2(TIME * speed, 0.0);
    COLOR = texture(TEXTURE, shifted_uv);
}