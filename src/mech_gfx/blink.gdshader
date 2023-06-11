shader_type canvas_item;

void fragment() {
	COLOR.a *= float(int(TIME * 30.0) % 2);
}
