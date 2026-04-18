extends Node2D
class_name Decoder

const MORSE_TO_ALPHA : Dictionary[String, String] = {
    ".-": "A",
    "-...": "B",
    "-.-.": "C",
    "-..": "D",
    ".": "E",
    "..-.": "F",
    "--.": "G",
    "....": "H",
    "..": "I",
    ".---": "J",
    "-.-": "K",
    ".-..": "L",
    "--": "M",
    "-.": "N",
    "---": "O",
    ".--.": "P",
    "--.-": "Q",
    ".-.": "R",
    "...": "S",
    "-": "T",
    "..-": "U",
    "...-": "V",
    ".--": "W",
    "-..-": "X",
    "-.--": "Y",
    "--..": "Z",
}

@onready var border_sprite: Sprite2D = %BorderSprite
@onready var letter_sprite: AnimatedSprite2D = %LetterSprite

var current_alpha = " "


func decode(bits: Array[bool]) -> void:
    current_alpha = bits_to_alpha(bits)
    letter_sprite.play(current_alpha)


func bits_to_alpha(bits: Array[bool]) -> String:
    bits.append(false)
    var morse: String = ""

    var length := 0
    for bit in bits:
        if bit == true:
            length += 1
        else:
            if length == 1:
                morse += "."
            elif length > 1:
                morse += "-"
            length = 0

    if morse.length() == 0:
        return " "

    var alpha = MORSE_TO_ALPHA.get(morse, "?")
    return alpha
