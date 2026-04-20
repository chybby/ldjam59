extends MarginContainer
class_name SpeechBubble

signal done

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

const TIME_UNIT = 0.04

@export var text: String
@export var dit_stream: AudioStream
@export var dah_stream: AudioStream

@onready var label: RichTextLabel = %Label
@onready var morse_audio_player: AudioStreamPlayer = %MorseAudioPlayer

var playing = false


func _ready() -> void:
    modulate = Color.TRANSPARENT
    label.text = text
    label.visible_characters = 0


func is_playing() -> bool:
    return playing


func play_char(c: String) -> void:
    if c == " ":
        await get_tree().create_timer(TIME_UNIT * 7).timeout
    elif c.to_upper() in ALPHA_TO_MORSE:
        var morse = ALPHA_TO_MORSE[c.to_upper()]
        var first_char = true
        for mc in morse:
            if first_char:
                first_char = false
            else:
                await get_tree().create_timer(TIME_UNIT).timeout

            if mc == ".":
                morse_audio_player.stream = dit_stream
            else:
                morse_audio_player.stream = dah_stream
            morse_audio_player.play()
            await morse_audio_player.finished


func collapse() -> void:
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "scale:y", 0, 0.2).from(1)
    await tween.finished


func play() -> void:
    playing = true
    scale.y = 0
    modulate = Color.WHITE
    await create_tween().tween_property(self, "scale:y", 1, 0.2).from(0).finished

    while label.visible_characters < label.text.length():
        var cur_char = label.text[label.visible_characters]
        label.visible_characters += 1
        await play_char(cur_char)
        await get_tree().create_timer(TIME_UNIT * 3).timeout

    playing = false
    done.emit()
