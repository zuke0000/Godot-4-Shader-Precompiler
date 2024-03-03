shader_type spatial;
render_mode unshaded;

uniform float zNear = 1.0;
uniform float zFar = 5.0;

uniform vec4 effectColor : source_color = vec4(1);
uniform bool flatColor = false;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float _linearizeScale(vec4 view){
	float linearDepth = vec3((view.xyz / view.w)).z;
	float depthScaled =  2.0 * (zNear * zFar) / (zFar + (linearDepth * zNear));
	return depthScaled;
}

void fragment() {
	//depth sample at screen_uv coords;
	float depthSample = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	
	vec3 ndc = vec3(SCREEN_UV, depthSample);
	vec4 view = (INV_PROJECTION_MATRIX * vec4(ndc, 1.0));
	float realDepth = _linearizeScale(view);
	
	if (flatColor) {
		if (realDepth > 0.0) {
			realDepth = 1.0;
		}
	}
	
	ALBEDO = vec3(realDepth) * effectColor.rgb;
	
//	debug;
//	vec4 originalColor = texture(SCREEN_TEXTURE, SCREEN_UV);
//	ALBEDO = originalColor.rgb;
}