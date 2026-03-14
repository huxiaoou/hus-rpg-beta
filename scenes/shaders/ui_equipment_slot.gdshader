shader_type canvas_item;

uniform sampler2D mask_tex;

void fragment() {
    float shrink_scale = 0.995;
    vec2 final_uv = UV / shrink_scale - vec2((1.0-shrink_scale)/2.0);
    if (final_uv.x < 0.0 || final_uv.x > 1.0 || final_uv.y < 0.0 || final_uv.y > 1.0) {
        COLOR = vec4(0.0); // Transparent outside the shrunk area
    }
    else{
        COLOR = texture(TEXTURE, final_uv);
    }

    float r = 0.9;
    vec4 mask_color = texture(mask_tex, final_uv);
    if (mask_color.a == 0.0){
        COLOR = mask_color;
    }
    else{
        COLOR = r * COLOR  + (1.0 - r) * mask_color;
    }
}
