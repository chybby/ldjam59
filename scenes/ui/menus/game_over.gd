extends CanvasLayer

@onready var back_button: SoundButton = %BackButton


func _ready() -> void:
    back_button.pressed.connect(on_back_button_pressed)

    back_button.hide()
    Narrator.add_message("YOU DID IT.")
    Narrator.add_message("THANK YOU.")
    Narrator.add_message("<3")

    await Narrator.messages_empty
    back_button.show()


func on_back_button_pressed() -> void:
    Transition.transition()
    await Transition.obscuring
    Narrator.reset()
    get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
