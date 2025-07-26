shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float pixelate_amt;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pixel_uv = round(UV * pixelate_amt)/pixelate_amt;
	vec4 noise_tex = texture(noise, vec2(pixel_uv.x, pixel_uv.y));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
