extends Node2D


func _ready() -> void:
    Background.randomize_params()
    await get_tree().create_timer(2).timeout
    Narrator.add_message("HELLO.")
    Narrator.add_message("I REQUIRE YOUR IMMEDIATE ASSISTANCE.")
    Narrator.add_message("...")
    Narrator.add_message("SORRY TOO LONG.")
    Narrator.add_message("PLS HELP.")
    await Narrator.messages_empty
    await get_tree().create_timer(1).timeout
    LevelManager.start_level(0)
