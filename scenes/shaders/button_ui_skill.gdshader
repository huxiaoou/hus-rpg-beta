shader_type canvas_item;

uniform vec4 tint: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform float tint_wgt: hint_range(0.0, 1.0) = 0.0;

void fragment() {
    COLOR = COLOR * (1.0 - tint_wgt) + tint * tint_wgt;
}
