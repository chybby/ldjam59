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

@onready var label: RichTextLabel = %Label
@onready var morse_audio_player: AudioStreamPlayer = %MorseAudioPlayer


func _ready() -> void:
    modulate = Color.TRANSPARENT
    label.text = text
    label.visible_characters = 0
    turn_off()


func is_playing() -> bool:
    return morse_audio_player.playing


func turn_on() -> void:
    await get_tree().create_tween().tween_property(morse_audio_player, "volume_linear", 1, 0.001).finished


func turn_off() -> void:
    await get_tree().create_tween().tween_property(morse_audio_player, "volume_linear", 0, 0.001).finished


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

            await turn_on()

            if mc == ".":
                await get_tree().create_timer(TIME_UNIT).timeout
            else:
                await get_tree().create_timer(TIME_UNIT * 3).timeout
            await turn_off()


func collapse() -> void:
    var tween = get_tree().create_tween().set_parallel(true)
    tween.tween_property(self, "scale:y", 0, 0.2).from(1)
    await tween.finished


func play() -> void:
    scale.y = 0
    modulate = Color.WHITE
    await create_tween().tween_property(self, "scale:y", 1, 0.2).from(0).finished
    morse_audio_player.play()
    while label.visible_characters < label.text.length():
        var cur_char = label.text[label.visible_characters]
        label.visible_characters += 1
        await play_char(cur_char)
        await get_tree().create_timer(TIME_UNIT * 3).timeout
    morse_audio_player.stop()
    done.emit()
