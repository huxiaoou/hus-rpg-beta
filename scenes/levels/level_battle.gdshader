shader_type canvas_item;

uniform float fov : hint_range(0.1, 2.0) = 0.5;
uniform float curvature : hint_range(0.0, 1.0) = 0.0; // Optional "bend"

void fragment() {
    vec2 uv = UV;
    
    // Offset UV to center (0.0 is middle)
    uv.x -= 0.5;
    
    // The "Magic": Divide X by Y to create perspective
    // As uv.y gets smaller (top of screen), uv.x gets stretched wider
    uv.x /= (uv.y * fov + (1.0 - fov));
    
    // Move UV back to standard 0.0 - 1.0 range
    uv.x += 0.5;
    
    // Clip the pixels outside the trapezoid
    if (uv.x < 0.0 || uv.x > 1.0) {
        discard;
    }
    
    COLOR = texture(TEXTURE, uv);
}