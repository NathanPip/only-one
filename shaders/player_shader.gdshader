shader_type canvas_item;

uniform vec3 damage_color: source_color;
uniform float damage_amt = 0;
uniform vec3 heal_color: source_color;
uniform float heal_amt = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = mix(mix(COLOR, vec4(damage_color, COLOR.a), damage_amt), vec4(heal_color, COLOR.a), heal_amt);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
