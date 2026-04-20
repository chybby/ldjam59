extends CanvasLayer
class_name MainMenu

@onready var play_button: Button = %PlayButton
@onready var rand_button: Button = %RandButton

func _ready() -> void:
    Background.randomize_params()
    play_button.pressed.connect(on_button_pressed)
    rand_button.pressed.connect(on_rand)


func on_button_pressed() -> void:
    Transition.transition()
    await Transition.obscuring
    get_tree().change_scene_to_file("res://scenes/levels/intro.tscn")

func on_rand() -> void:
    Background.randomize_params()
