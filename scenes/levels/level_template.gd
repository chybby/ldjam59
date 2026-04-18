extends Node2D
class_name LevelTemplate

signal next_level_button_pressed

@onready var next_level_button: SoundButton = %NextLevelButton


func _ready() -> void:
    next_level_button.pressed.connect(on_next_level_button_pressed)


func show_next_level_button() -> void:
    next_level_button.visible = true


func on_next_level_button_pressed() -> void:
    next_level_button_pressed.emit()
