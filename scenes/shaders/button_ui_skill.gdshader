shader_type canvas_item;

uniform vec4 tint: source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform bool use_gradient = false;
uniform float border_width = 0.0125;

uniform sampler2D border_tex;
uniform sampler2D gradient_tex;

void fragment() {
    vec2 uv = UV;
    if (uv.x < border_width || uv.x > 1.0 - border_width || uv.y < border_width || uv.y > 1.0 - border_width) {
        COLOR = texture(border_tex, uv);
    }
    else{
        if (use_gradient) {
            float wgt = pow(texture(gradient_tex, uv).r, 0.618);
            COLOR = COLOR * (1.0 - wgt) + tint * wgt;
        }
    }
}
