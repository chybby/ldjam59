extends Node2D
class_name Grid

@onready var board: TileMapLayer = %Board
@onready var tiles: TileMapLayer = %Tiles

var horizontal_decoders: Dictionary[int, Decoder] = {}
var vertical_decoders: Dictionary[int, Decoder] = {}


func add_horizontal_decoder(decoder: Decoder) -> void:
    var coords = board.local_to_map(decoder.position)
    horizontal_decoders[coords.y] = decoder


func add_vertical_decoder(decoder: Decoder) -> void:
    var coords = board.local_to_map(decoder.position)
    vertical_decoders[coords.x] = decoder


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.is_action_released("click"):
            var coords := tiles.local_to_map(event.position)
            toggle(coords)


func is_enabled_cell(coords: Vector2i) -> bool:
    var board_data := board.get_cell_tile_data(coords)
    return board_data.get_custom_data("Enabled")


func toggle(coords: Vector2i) -> void:
    if not is_enabled_cell(coords):
        return

    var tile_data := tiles.get_cell_tile_data(coords)
    if tile_data == null:
        tiles.set_cell(coords, 1, Vector2i(4, 4))
        check()
    elif not tile_data.get_custom_data("Locked"):
        tiles.set_cell(coords, -1)
        check()


func check() -> void:
    var used_rect := board.get_used_rect()
    for y in horizontal_decoders:
        var decoder := horizontal_decoders[y]
        var bits : Array[bool] = []
        for x in range(used_rect.position.x, used_rect.end.x):
            if is_enabled_cell(Vector2i(x, y)):
                var tile_data := tiles.get_cell_tile_data(Vector2i(x, y))
                if tile_data == null:
                    bits.append(false)
                else:
                    bits.append(tile_data.get_custom_data("On"))
        decoder.decode(bits)

    for x in vertical_decoders:
        var decoder := vertical_decoders[x]
        var bits : Array[bool] = []
        for y in range(used_rect.position.y, used_rect.end.y):
            if is_enabled_cell(Vector2i(x, y)):
                var tile_data := tiles.get_cell_tile_data(Vector2i(x, y))
                if tile_data == null:
                    bits.append(false)
                else:
                    bits.append(tile_data.get_custom_data("On"))
        decoder.decode(bits)
