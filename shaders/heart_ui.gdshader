shader_type canvas_item;

uniform vec3 border_color: source_color;
uniform vec3 inner_color: source_color;
uniform vec3 inner_color_dead: source_color;
uniform float dead_amt;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color_1 = COLOR.r * inner_color;
	vec3 color_2_2 = COLOR.r * inner_color_dead;
	color_1 = mix(color_1, color_2_2, dead_amt);
	vec3 color_2 = COLOR.g * border_color;
	vec3 color_3 = vec3(0,0,0);
	COLOR = vec4(color_1 + color_2 + color_3, COLOR.a);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
