shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform float speed;
uniform float lightness = .2f;
uniform float pixelate_amt;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pixel_uv = round(UV * pixelate_amt)/pixelate_amt;
	vec4 noise_tex = texture(noise, vec2(pixel_uv.x - TIME * speed, pixel_uv.y + TIME * speed));
	vec4 noise_tex2 = texture(noise2, vec2(pixel_uv.x + TIME * speed, pixel_uv.y));
	vec4 noise_combine = noise_tex * noise_tex2 * lightness;
	noise_combine.a = 1.f;
	COLOR = noise_combine;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
