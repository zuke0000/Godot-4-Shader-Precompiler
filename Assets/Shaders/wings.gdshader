

shader_type spatial;

render_mode diffuse_toon, cull_disabled;

uniform sampler2D wing_tex : hint_default_white;
uniform sampler2D mask_tex : hint_default_white;
uniform sampler2D pattern_tex : hint_default_white;
uniform sampler2D gradient_tex : hint_default_black;

uniform float displ_strengh = 0.3;
uniform float wave_frequency = 2.0;
uniform float speed = 0.2;
uniform float emission_strengh = 0.0;


void vertex() {
	VERTEX.y += displ_strengh * UV.x * sin(VERTEX.x * wave_frequency + TIME * 4.0*speed);
}


void fragment() {
	
	vec2 uv_movement = UV;
	uv_movement -= speed * (TIME * vec2(1.0, 0.0));
	
	vec4 wing = texture(wing_tex, uv_movement);
	vec4 mask = texture(mask_tex, UV);
	vec4 pattern = texture(pattern_tex, uv_movement * vec2(2.0, 1.0));
	vec3 gradient = texture(gradient_tex, UV).rgb;
	
	vec3 emission = emission_strengh * gradient;
	
	vec3 alter_mask = mask.rgb * pattern.rgb;
	
	
	ALBEDO = wing.rgb * gradient.rgb * alter_mask.rgb;
	ALPHA = wing.r * mask.r;
	EMISSION = emission * pattern.rgb * alter_mask.rgb;
}