shader_type canvas_item;

uniform vec4 damage_color: source_color;
uniform sampler2D noise: repeat_enable;
uniform sampler2D noise2: repeat_enable;
uniform float speed;
uniform float lightness = .2f;
uniform float pixelate_amt;
uniform float damage_amt = 0;
uniform float flash_amt = .2;
uniform float shake_amt = 5;
uniform float shake_speed = 5;

float inverseLerp(float v, float minValue, float maxValue) {
	return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
	float t = inverseLerp(v, inMin, inMax);
	return mix(outMin, outMax, t);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pixel_uv = round(UV * pixelate_amt)/pixelate_amt;
	vec4 noise_tex = texture(noise, vec2(pixel_uv.x - TIME * speed + remap(sin(PI*(damage_amt * shake_speed)), 0.f, 1.f, -shake_amt, shake_amt), pixel_uv.y + TIME * speed - remap(sin(PI*(damage_amt * shake_speed)-PI/2.f), 0.f, 1.f, -shake_amt, shake_amt)));
	vec4 noise_tex2 = texture(noise2, vec2(pixel_uv.x + TIME * speed + remap(sin(PI*(damage_amt * shake_speed)), 0.f, 1.f, -shake_amt, shake_amt), pixel_uv.y - TIME * speed - remap(sin(PI*(damage_amt * shake_speed)-PI/2.f), 0.f, 1.f, -shake_amt, shake_amt)));
	vec4 noise_combine = noise_tex * noise_tex2 * mix(lightness, flash_amt, damage_amt) * mix(vec4(1), damage_color, damage_amt);
	noise_combine.a = 1.f;
	COLOR = noise_combine;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
