shader_type canvas_item;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR = screen_color.rrrr;
}
