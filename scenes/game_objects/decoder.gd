extends Node2D
class_name Decoder

const MORSE_TO_ALPHA: Dictionary[String, String] = {
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

signal updated
signal interacted

@onready var monitor_sprite: AnimatedSprite2D = %MonitorSprite
@onready var indicator_sprite: AnimatedSprite2D = %IndicatorSprite
@onready var letter_sprite: AnimatedSprite2D = %LetterSprite
@onready var mouse_area: Area2D = %MouseArea
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@export var wanted_letter: String = ""
@export var invertible: bool = false:
    set(value):
        invertible = value
        if mouse_area != null:
            mouse_area.input_pickable = invertible
@export var show_lock: bool = false

var current_bits: Array[bool] = []
var current_alpha := " "
var inverted := false


func _ready() -> void:
    letter_sprite.modulate = Color("b9d4b4ff")
    if not invertible:
        mouse_area.input_pickable = false
    mouse_area.input_event.connect(on_mouse_event)
    update_monitor_sprite()


func reset() -> void:
    if invertible and inverted:
        invert()


func is_wanted_letter() -> bool:
    return wanted_letter == current_alpha


func decode(bits: Array[bool]) -> void:
    current_bits = bits
    current_alpha = bits_to_alpha(bits)

    if is_wanted_letter():
        indicator_sprite.play("correct")
    else:
        indicator_sprite.play("wrong")

    letter_sprite.play(current_alpha)


func bits_to_alpha(bits: Array[bool]) -> String:
    var bits_copy = bits.duplicate()
    var morse: String = ""

    if inverted:
        bits_copy = bits_copy.map(func(x): return not x)

    bits_copy.append(false)
    var length := 0
    for bit in bits_copy:
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


func update_monitor_sprite() -> void:
    if inverted:
        if invertible or not show_lock:
            monitor_sprite.play("inverted")
        else:
            monitor_sprite.play("locked_inverted")
    else:
        if invertible or not show_lock:
            monitor_sprite.play("default")
        else:
            monitor_sprite.play("locked")


func invert() -> void:
    inverted = !inverted
    update_monitor_sprite()
    decode(current_bits)
    updated.emit()
    if inverted:
        letter_sprite.modulate = Color("355d69ff")
    else:
        letter_sprite.modulate = Color("b9d4b4ff")

func on_mouse_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event.is_action_released("click"):
        audio_stream_player.play()
        interacted.emit()
        invert()
