extends Node

@export var music_atten_factor: float
@export var music_atten_time_in: float
@export var music_atten_time_out: float

var num_attenuating = 0
var curr_max: float
var curr_min: float
var in_tween: Tween
var out_tween: Tween

func attenuate() -> Callable:
    num_attenuating += 1
    var music_bus_idx = AudioServer.get_bus_index("Music")
    var music_bus_volume = AudioServer.get_bus_volume_linear(music_bus_idx)
    if num_attenuating == 1:
        curr_max = music_bus_volume
        curr_min = music_bus_volume*music_atten_factor
    var set_music_bus_volume = func(vol):
        AudioServer.set_bus_volume_linear(music_bus_idx, vol)
    if in_tween:
        in_tween.kill()
    if out_tween:
        out_tween.kill()
    in_tween = get_tree().create_tween()
    in_tween.tween_method(set_music_bus_volume, music_bus_volume, curr_min, music_atten_time_in)
    return func():
        music_bus_volume = AudioServer.get_bus_volume_linear(music_bus_idx)
        if out_tween:
            out_tween.kill()
        if in_tween:
            in_tween.kill()
        out_tween = get_tree().create_tween()
        out_tween.tween_method(set_music_bus_volume, music_bus_volume, curr_max, music_atten_time_out)
        out_tween.tween_callback(func():
            num_attenuating -= 1
        )
