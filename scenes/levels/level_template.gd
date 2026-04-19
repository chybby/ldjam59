extends Node2D
class_name LevelTemplate

signal next_level_button_pressed

@onready var next_level_button: SoundButton = %NextLevelButton
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var button_shown = false

func _ready() -> void:
    next_level_button.pressed.connect(on_next_level_button_pressed)


func show_next_level_button() -> void:
    if button_shown:
        return

    animation_player.play("show_button")
    button_shown = true


func on_next_level_button_pressed() -> void:
    next_level_button_pressed.emit()
