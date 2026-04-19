extends Node

@export var levels: Array[PackedScene] = []
@export var game_over_screen : PackedScene = null

var current_level_index := -1
var current_level : Level = null


func start_level(index: int) -> void:
    current_level_index = index
    print("Starting level %d" % index)
    var old_level = current_level
    current_level = levels[index].instantiate()
    current_level.finished_level.connect(on_finished_level)
    Transition.transition()
    await Transition.obscuring
    Narrator.reset()
    get_tree().change_scene_to_node(current_level)


    if old_level != null:
        old_level.queue_free()


func on_finished_level() -> void:
    current_level_index += 1

    if current_level_index == levels.size():
        current_level.queue_free()
        current_level = null
        current_level_index = -1
        get_tree().change_scene_to_packed(game_over_screen)
    else:
        start_level(current_level_index)
