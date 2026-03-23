shader_type canvas_item;

uniform vec4 tint: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform bool use_gradient = false;
uniform bool use_highlitht = true;
uniform vec4 shine_color : source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform float border_width : hint_range(0.0, 0.1) = 0.025;
uniform float shine_size : hint_range(0.0, 0.5) = 0.1;
uniform float speed : hint_range(0.0, 5.0) = 0.3;

uniform sampler2D border_tex;
uniform sampler2D gradient_tex;

void fragment() {
    vec2 uv = UV;
    vec4 tex_color = texture(TEXTURE, uv);

    // Check if we are within the border area
    float left = step(uv.x, border_width);
    float right = step(1.0 - border_width, uv.x);
    float top = step(uv.y, border_width);
    float bottom = step(1.0 - border_width, uv.y);

    // 1 if is in border scope else 0
    float is_border = max(max(left, right), max(top, bottom));

    // Apply the border over the texture
    if (is_border > 0.0){
        if (use_highlitht){
            // Calculate progress along the perimeter (0.0 to 1.0)
            float progress = fract(TIME * speed);

            // Map UV to a 1D perimeter value
            float perimeter_pos = 0.0;
            if (uv.y <= border_width) perimeter_pos = uv.x * 0.25; // Top
            else if (uv.x >= 1.0 - border_width) perimeter_pos = 0.25 + uv.y * 0.25; // Right
            else if (uv.y >= 1.0 - border_width) perimeter_pos = 0.5 + (1.0 - uv.x) * 0.25; // Bottom
            else if (uv.x <= border_width) perimeter_pos = 0.75 + (1.0 - uv.y) * 0.25; // Left

            // Calculate the shine intensity based on distance to the progress point
            float dist = abs(perimeter_pos - progress);

            // Handle the wrap-around case (1.0 back to 0.0)
            dist = min(dist, 1.0 - dist);
            float shine_mask = 1.0 - smoothstep(0.0, shine_size, dist);

            // Mix the colors
            COLOR = mix(tex_color, shine_color, shine_mask);
        }
    }else{
        if (use_gradient) {
            COLOR = mix(COLOR, tint, texture(gradient_tex, uv).r);
        }
    }
}