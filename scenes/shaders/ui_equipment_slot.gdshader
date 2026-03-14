shader_type canvas_item;

uniform sampler2D mask_tex;

void fragment() {
    float r = 1.0;
    vec4 mask_color = texture(mask_tex, UV);
    if (mask_color.a == 0.0){
        COLOR = mask_color;
    }
    else{
        COLOR = r * COLOR  + (1.0 - r) * mask_color;
    }
}
