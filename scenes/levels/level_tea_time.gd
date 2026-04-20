extends Level

@onready var vertical_morse: Node2D = %VerticalMorse
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
    super()
    vertical_morse.hide()
    vertical_decoders_parent.hide()


func on_grid_updated() -> void:
    super()

    if vertical_morse.visible:
        return

    if horizontal_decoders.all(func (d: Decoder): return d.is_wanted_letter()):
        vertical_morse.show()
        vertical_decoders_parent.show()
        animation_player.play("show")
