extends CanvasLayer
class_name MainMenu

signal started_game

@onready var button: Button = %Button


func _ready() -> void:
    button.pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
    started_game.emit()
