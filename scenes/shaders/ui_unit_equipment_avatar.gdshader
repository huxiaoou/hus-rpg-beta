shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
    float r0 = 0.5;
    float r1 = 0.48;
    float d = distance(UV, vec2(0.5));
    if ( d > r0) {
        COLOR = vec4(0);
    }else if (d > r1){
        COLOR = vec4(1);
    }else {
        vec4 color_tex = texture(TEXTURE, UV);
        if (color_tex.a <= 0.1){
            COLOR = vec4(0.2, 0.2, 0.2, 1);
        }
    }
    
}
