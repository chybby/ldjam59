extends Node2D
class_name MorseLetter

signal played

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
@export var dit_stream: AudioStream
@export var dah_stream: AudioStream
@export var music_atten_factor: float
@export var music_atten_time_in: float
@export var music_atten_time_out: float

@onready var mouse_area: Area2D = %MouseArea
@onready var morse_audio_player: AudioStreamPlayer = %MorseAudioPlayer
@onready var light_sprite: AnimatedSprite2D = $LightSprite

var playing = false

func _ready() -> void:
    mouse_area.input_event.connect(on_mouse_event)
    mouse_area.mouse_exited.connect(on_mouse_exited)


func play() -> void:
    playing = true
    played.emit()
    
    # music down
    var music_bus_idx = AudioServer.get_bus_index("Music")
    var music_bus_volume = AudioServer.get_bus_volume_linear(music_bus_idx)
    var set_music_bus_volume = func(vol):
        AudioServer.set_bus_volume_linear(music_bus_idx, vol)
    var in_tween = get_tree().create_tween()
    in_tween.tween_method(set_music_bus_volume, music_bus_volume, music_bus_volume*music_atten_factor, music_atten_time_in)
    
    var morse := ALPHA_TO_MORSE[letter]

    for c in morse:
        await get_tree().create_timer(0.1).timeout
        light_sprite.play("lit")
        if c == ".":
            morse_audio_player.stream = dit_stream
        else:
            morse_audio_player.stream = dah_stream
        morse_audio_player.play()
        await morse_audio_player.finished
        light_sprite.play("pressed")

    await get_tree().create_timer(0.5).timeout
    light_sprite.play("default")
    playing = false
    
    # music up
    var out_tween = get_tree().create_tween()
    out_tween.tween_method(set_music_bus_volume, music_bus_volume*music_atten_factor, music_bus_volume, music_atten_time_out)


func on_mouse_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if playing:
        return
    if event.is_action_pressed("click"):
        light_sprite.play("pressed")
    elif event.is_action_released("click"):
        play()


func on_mouse_exited() -> void:
    if playing:
        return
    light_sprite.play("default")
