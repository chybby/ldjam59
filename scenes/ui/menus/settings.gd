extends CanvasLayer

@onready var music_slider: HSlider = %MusicSlider
@onready var effects_slider: HSlider = %EffectsSlider
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var fade: ColorRect = %Fade


func _ready() -> void:
    music_slider.value_changed.connect(on_music_slider_value_changed)
    effects_slider.value_changed.connect(on_effects_slider_value_changed)

    on_music_slider_value_changed(music_slider.value)
    on_effects_slider_value_changed(effects_slider.value)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        if get_tree().paused:
            unpause()
        else:
            pause()


func pause() -> void:
    fade.mouse_filter = Control.MOUSE_FILTER_STOP
    get_tree().paused = true
    animation_player.play("show")


func unpause() -> void:
    fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
    get_tree().paused = false
    animation_player.play_backwards("show")


func on_music_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)


func on_effects_slider_value_changed(value: float) -> void:
    AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
