shader_type canvas_item;

varying vec2 world_pos;

uniform vec4 color1 : source_color = vec4(1.0);
uniform vec4 color2 : source_color = vec4(1.0);
uniform vec4 color3 : source_color = vec4(1.0);

uniform vec3 amps;    // 5 - 50
uniform vec3 freqs;   // 0.3 - 0.01
uniform vec3 ys;      // 250 - 300
uniform vec3 ws;      // 5 - 50
uniform vec3 speeds;  // 1 - 7

void vertex() {
	// Called for every vertex the material is visible on.
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

bool on_curve(vec2 v, float amp, float freq, float y, float w, float speed) {
    float s = amp * sin((v.x + TIME * speed) * freq) + y;
    float c = amp * freq * cos(freq * (v.x + speed));
    float d = abs(s - v.y);
    return d < w * sqrt(1.0 + c * c);
}

void fragment() {
    if (on_curve(world_pos,
                 amps.x,
                 freqs.x,
                 ys.x,
                 ws.x,
                 speeds.x
                )) {
        COLOR = color1;
    }
    if (on_curve(world_pos,
                 amps.y,
                 freqs.y,
                 ys.y,
                 ws.y,
                 speeds.y
                )) {
        COLOR = color2;
    }
    if (on_curve(world_pos,
                 amps.z,
                 freqs.z,
                 ys.z,
                 ws.z,
                 speeds.z
                )) {
        COLOR = color3;
    }
}
