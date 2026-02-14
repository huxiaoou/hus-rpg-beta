shader_type canvas_item;

uniform float speed = 0.5;
uniform float dash_density = 1.0;

void fragment() {
    // Shift the UV.x over time based on speed
    // mod() ensures the value stays within the 0.0 - 1.0 range
    vec2 moving_uv = vec2(UV.x * dash_density + (TIME * speed), UV.y);
    
    // Create the dash pattern using a step function
    float dash = step(0.5, fract(moving_uv.x));
    
    // Apply the dash to the alpha channel
    COLOR.a *= dash;
}