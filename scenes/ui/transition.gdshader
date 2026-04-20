shader_type canvas_item;

varying vec2 world_pos;

uniform vec4 color : source_color = vec4(1.0);

uniform float uamp;    // 5 - 50
uniform float ufreq;   // 0.3 - 0.01
uniform float uy;      // 250 - 300
uniform float uw;      // 5 - 50
uniform float uspeed;  // 1 - 7

void vertex() {
	// Called for every vertex the material is visible on.
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

bool on_curve(vec2 v, float amp, float freq, float y, float w, float speed) {
    float s = amp * sin((v.x + TIME * speed) * freq) + y;
    float d = abs(s - v.y);
    return d < w;
}

void fragment() {
    if (on_curve(world_pos,
                 uamp,
                 ufreq,
                 uy,
                 uw,
                 uspeed
                )) {
        COLOR = color;
    }
}
