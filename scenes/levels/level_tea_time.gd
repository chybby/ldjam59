extends Level

@onready var vertical_morse: Node2D = %VerticalMorse


func _ready() -> void:
    super()


func on_decoder_updated(decoder: Decoder) -> void:
    super(decoder)

    if vertical_morse.visible:
        return

    if horizontal_decoders.all(func (d: Decoder): return d.is_wanted_letter()):
        vertical_morse.show()
        vertical_decoders_parent.show()
