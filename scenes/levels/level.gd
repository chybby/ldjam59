extends Node2D
class_name Level

signal finished_level

@onready var grid: Grid = %Grid
@onready var horizontal_decoders_parent: Node2D = %HorizontalDecoders
@onready var vertical_decoders_parent: Node2D = %VerticalDecoders
@onready var level_template: LevelTemplate = %LevelTemplate

var horizontal_decoders : Array[Decoder] = []
var vertical_decoders : Array[Decoder] = []


func _ready() -> void:
    Background.randomize_params()
    for decoder in horizontal_decoders_parent.get_children() as Array[Decoder]:
        grid.add_horizontal_decoder(decoder)
        horizontal_decoders.append(decoder)
        decoder.updated.connect(on_grid_updated)

    for decoder in vertical_decoders_parent.get_children()  as Array[Decoder]:
        grid.add_vertical_decoder(decoder)
        vertical_decoders.append(decoder)
        decoder.updated.connect(on_grid_updated)

    level_template.next_level_button_pressed.connect(on_next_level_button_pressed)
    level_template.reset_button_pressed.connect(on_reset_button_pressed)

    grid.updated.connect(on_grid_updated)
    grid.check()


func check_win() -> void:
    # By default, you win a level if all decoders are their wanted letter.
    if horizontal_decoders.all(func (d: Decoder): return d.is_wanted_letter()) and vertical_decoders.all(func (d: Decoder): return d.is_wanted_letter()):
        finish_level()


func finish_level() -> void:
    level_template.show_next_level_button()


func on_next_level_button_pressed() -> void:
    finished_level.emit()


func on_reset_button_pressed() -> void:
    for d in horizontal_decoders:
        d.reset()
    for d in vertical_decoders:
        d.reset()
    grid.reset()


func on_grid_updated() -> void:
    check_win()
