extends CanvasLayer

signal obscuring

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func emit_obscuring() -> void:
    obscuring.emit()


func transition() -> void:
    animation_player.play("transition")
