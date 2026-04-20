extends Level

@onready var morse_letter: MorseLetter = %MorseLetter
@onready var arrow: Node2D = %Arrow
@onready var second_arrow_position: Marker2D = %SecondArrowPosition

var tut_done = false

func _ready() -> void:
    super()
    arrow.hide()

    await get_tree().create_timer(0.5).timeout

    Narrator.add_message("PRESS PLAY.")
    arrow.show()
    morse_letter.played.connect(on_played)


func on_played() -> void:
    if tut_done:
        return
    tut_done = true

    arrow.hide()
    await get_tree().create_timer(2).timeout
    Narrator.add_message("SEND THE SIGNAL.")
    arrow.position = second_arrow_position.position
    arrow.show()
    await grid.interacted
    arrow.hide()
