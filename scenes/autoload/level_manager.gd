extends Node

@export var levels: Array[PackedScene] = []
@export var game_over_screen : PackedScene = null

var current_level_index := -1
var current_level : Level = null

func _ready() -> void:
    var main_menu = get_tree().get_first_node_in_group("MainMenu")
    if main_menu != null:
        main_menu.started_game.connect(on_start_game)


func start_level(index: int) -> void:
    print("Starting level %d" % index)
    var old_level = current_level
    current_level = levels[index].instantiate()
    current_level.finished_level.connect(on_finished_level)
    get_tree().change_scene_to_node(current_level)

    if old_level != null:
        old_level.queue_free()


func on_start_game() -> void:
    current_level_index = 0
    start_level(current_level_index)


func on_finished_level() -> void:
    current_level_index += 1

    if current_level_index == levels.size():
        current_level.queue_free()
        current_level = null
        current_level_index = -1
        get_tree().change_scene_to_packed(game_over_screen)
    else:
        start_level(current_level_index)
