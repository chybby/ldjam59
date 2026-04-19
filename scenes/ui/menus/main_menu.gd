extends CanvasLayer
class_name MainMenu

@onready var button: Button = %Button


func _ready() -> void:
    button.pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
    Transition.transition()
    await Transition.obscuring
    get_tree().change_scene_to_file("res://scenes/levels/intro.tscn")
