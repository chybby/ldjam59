extends CanvasLayer


@onready var color_rect: ColorRect = %ColorRect


const AMPS_MIN = 5
const AMPS_MAX = 50
const FREQS_MIN = 0.01
const FREQS_MAX = 0.1
const YS_MIN = 225
const YS_MAX = 300
const WS_MIN = 5
const WS_MAX = 25
const SPEEDS_MIN = -10
const SPEEDS_MAX = 10


func randomize_params() -> void:
    var shader := color_rect.material as ShaderMaterial
    shader.set_shader_parameter("amps", Vector3(randf_range(AMPS_MIN, AMPS_MAX), randf_range(AMPS_MIN, AMPS_MAX), randf_range(AMPS_MIN, AMPS_MAX)))
    shader.set_shader_parameter("freqs", Vector3(randf_range(FREQS_MIN, FREQS_MAX), randf_range(FREQS_MIN, FREQS_MAX), randf_range(FREQS_MIN, FREQS_MAX)))
    shader.set_shader_parameter("ys", Vector3(randf_range(YS_MIN, YS_MAX), randf_range(YS_MIN, YS_MAX), randf_range(YS_MIN, YS_MAX)))
    shader.set_shader_parameter("ws", Vector3(randf_range(WS_MIN, WS_MAX), randf_range(WS_MIN, WS_MAX), randf_range(WS_MIN, WS_MAX)))
    shader.set_shader_parameter("speeds", Vector3(randf_range(SPEEDS_MIN, SPEEDS_MAX), randf_range(SPEEDS_MIN, SPEEDS_MAX), randf_range(SPEEDS_MIN, SPEEDS_MAX)))
