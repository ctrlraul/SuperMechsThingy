shader_type canvas_item;

void fragment() {
	COLOR.a *= float(int(TIME * 20.0) % 2);
}
