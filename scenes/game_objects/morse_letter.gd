@tool
extends Node2D

@export var letter : String = "A":
    set(new_letter):
        letter = new_letter
        if letter_sprite != null:
            letter_sprite.play(letter)

@onready var letter_sprite: AnimatedSprite2D = %LetterSprite


func _ready() -> void:
    letter_sprite.play(letter)
