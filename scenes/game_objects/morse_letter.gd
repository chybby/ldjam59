extends Node2D

const ALPHA_TO_MORSE: Dictionary[String, String] = {
    "A": ".-",
    "B": "-...",
    "C": "-.-.",
    "D": "-..",
    "E": ".",
    "F": "..-.",
    "G": "--.",
    "H": "....",
    "I": "..",
    "J": ".---",
    "K": "-.-",
    "L": ".-..",
    "M": "--",
    "N": "-.",
    "O": "---",
    "P": ".--.",
    "Q": "--.-",
    "R": ".-.",
    "S": "...",
    "T": "-",
    "U": "..-",
    "V": "...-",
    "W": ".--",
    "X": "-..-",
    "Y": "-.--",
    "Z": "--..",
}

@export var letter: String = "A"

@onready var mouse_area: Area2D = %MouseArea
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var light_sprite: AnimatedSprite2D = $LightSprite


func _ready() -> void:
    mouse_area.input_event.connect(on_mouse_event)


func fill_buffer() -> void:
    var playback := audio_stream_player.get_stream_playback() as AudioStreamGeneratorPlayback
    var pulse_hz = 440.0
    var phase = 0.0
    var increment = pulse_hz / audio_stream_player.stream.mix_rate
    var frames_available = playback.get_frames_available()

    for i in range(frames_available):
        playback.push_frame(Vector2.ONE * sin(phase * TAU))
        phase = fmod(phase + increment, 1.0)


func turn_on() -> void:
    light_sprite.play("lit")
    await get_tree().create_tween().tween_property(audio_stream_player, "volume_linear", 1, 0.02).finished


func turn_off() -> void:
    light_sprite.play("pressed")
    await get_tree().create_tween().tween_property(audio_stream_player, "volume_linear", 0, 0.02).finished


func play() -> void:
    audio_stream_player.volume_linear = 0
    audio_stream_player.play()
    var morse := ALPHA_TO_MORSE[letter]

    for c in morse:
        await get_tree().create_timer(0.1).timeout
        await turn_on()
        if c == ".":
            await get_tree().create_timer(0.1).timeout
        else:
            await get_tree().create_timer(0.3).timeout
        await turn_off()

    await get_tree().create_timer(0.5).timeout
    audio_stream_player.stop()
    light_sprite.play("default")


func on_mouse_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if audio_stream_player.playing:
        return
    if event.is_action_pressed("click"):
        light_sprite.play("pressed")
    elif event.is_action_released("click"):
        play()
