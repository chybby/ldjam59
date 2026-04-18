extends Node2D

@onready var board: TileMapLayer = %Board
@onready var tiles: TileMapLayer = %Tiles
@onready var horizontal_decoders_parent: Node2D = %HorizontalDecoders
@onready var vertical_decoders_parent: Node2D = %VerticalDecoders

var horizontal_decoders: Dictionary[int, Decoder] = {}
var vertical_decoders: Dictionary[int, Decoder] = {}


func _ready() -> void:
    for node in horizontal_decoders_parent.get_children() as Array[Node2D]:
        var coords = board.local_to_map(node.position)
        horizontal_decoders[coords.y] = node

    for node in vertical_decoders_parent.get_children() as Array[Node2D]:
        var coords = board.local_to_map(node.position)
        vertical_decoders[coords.x] = node

    check()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.is_action_released("click"):
            var coords := tiles.local_to_map(event.position)
            toggle(coords)


func toggle(coords: Vector2i) -> void:
    var board_data := board.get_cell_tile_data(coords)
    if not board_data.get_custom_data("Enabled"):
        return

    var tile_data := tiles.get_cell_tile_data(coords)
    if tile_data == null:
        tiles.set_cell(coords, 1, Vector2i(4, 4))
        check()
    elif not tile_data.get_custom_data("Locked"):
        tiles.set_cell(coords, -1)
        check()


func check() -> void:
    var used_rect := tiles.get_used_rect()
    for y in horizontal_decoders:
        var decoder := horizontal_decoders[y]
        var bits : Array[bool] = []
        for x in range(used_rect.position.x, used_rect.end.x + 1):
            var tile_data := tiles.get_cell_tile_data(Vector2i(x, y))
            if tile_data == null:
                bits.append(false)
            else:
                bits.append(tile_data.get_custom_data("On"))
        decoder.decode(bits)

    for x in vertical_decoders:
        var decoder := vertical_decoders[x]
        var bits : Array[bool] = []
        for y in range(used_rect.position.y, used_rect.end.y + 1):
            var tile_data := tiles.get_cell_tile_data(Vector2i(x, y))
            if tile_data == null:
                bits.append(false)
            else:
                bits.append(tile_data.get_custom_data("On"))
        decoder.decode(bits)
