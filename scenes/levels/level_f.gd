extends Level

@onready var arrow: Node2D = %Arrow
@onready var hor_decoder: Decoder = %HorDecoder


func _ready() -> void:
    super()
    arrow.hide()
    await get_tree().create_timer(15).timeout
    Narrator.add_message("IMPOSSIBLE.")
    await Narrator.messages_empty
    Narrator.add_message("INVERT THE SIGNAL.")
    arrow.show()
    hor_decoder.invertible = true
    await hor_decoder.interacted
    arrow.hide()
