
shader_type spatial;
render_mode unshaded;

uniform float look_right : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float look_up : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float eyelid_tl : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float eyelid_tl_rotation = 0.0;
uniform float eyelid_bl : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float eyelid_bl_rotation = 0.0;
uniform float eyelid_tr : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float eyelid_tr_rotation = 0.0;
uniform float eyelid_br : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float eyelid_br_rotation = 0.0;
uniform float eyelid_curve = 0.0;
uniform vec2 eyelid_top_position;
uniform vec2 eyelid_bot_position;
uniform vec2 pupil_position;
uniform vec2 pupil_length;
uniform float eye_separation = 0.2;
uniform float pupil_size = 0.1;
uniform float eyelid_size = 0.1;

uniform vec3 color_light : source_color;
uniform vec3 color_dark : source_color;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
    mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),  vec2(cos(angle), sin(angle)));
    uv -= pivot;
    uv = uv * rotation;
    uv += pivot;
    return uv;
}

float generate_eyes(vec2 uv) {
uv = uv + pupil_position + vec2(mix(0.08, -0.08,  look_right), mix(-0.6, -0.3, look_up));
    float p = distance(uv, vec2(0.5, clamp(uv.y, pupil_length.x, pupil_length.y)));
    return step(p, pupil_size - mix(0, pupil_size, uv.y / pupil_length.y));
}

float generate_eyelid(vec2 uv, vec2 pos, float lerp, vec2 border, float angle, bool is_top){
    vec2 offset = - vec2(0.5) + vec2(0.0, mix(pos.x, pos.y, lerp));
    vec2 base_uv = rotate(uv + vec2(0.0, pow((uv.x - 0.25 - border.x) / (border.y - border.x), 2.0) * eyelid_curve), vec2(0.5), angle + PI/2.0) + offset;
    float p = distance(base_uv, vec2(base_uv.x,is_top ? min(base_uv.y, 0.0) : max(base_uv.y, 0.0)));
    if(uv.x < border.x || uv.x > border.y){
        p = 1.0;
    }
    return step(p, eyelid_size);
 }

void fragment() {
    vec2 base_uv = UV;
    vec3 proc_eyes = vec3(generate_eyes(vec2(base_uv.x + eye_separation, base_uv.y)));
    proc_eyes += vec3(generate_eyes(vec2(base_uv.x - eye_separation, base_uv.y)));
    proc_eyes += vec3(generate_eyelid(base_uv, eyelid_top_position, eyelid_tl, vec2(0.5, 1.0), eyelid_tl_rotation, true));
    proc_eyes += vec3(generate_eyelid(base_uv, eyelid_bot_position, eyelid_bl, vec2(0.5, 1.0), eyelid_bl_rotation, false));
    proc_eyes += vec3(generate_eyelid(base_uv, eyelid_top_position, eyelid_tr, vec2(0.0, 0.5), -eyelid_tr_rotation, true));
    proc_eyes += vec3(generate_eyelid(base_uv, eyelid_bot_position, eyelid_br, vec2(0.0, 0.5), -eyelid_br_rotation, false));
    proc_eyes = clamp(proc_eyes, 0.0, 1.0);
    proc_eyes = mix(color_light, color_dark, proc_eyes.x);
    ALBEDO = proc_eyes;
}