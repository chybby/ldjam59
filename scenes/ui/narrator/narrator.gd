extends CanvasLayer

signal messages_empty

@export var speech_bubble_scene: PackedScene

@onready var speech_bubble_stack: VBoxContainer = %SpeechBubbleStack

var shown_speech_bubbles : Array[SpeechBubble] = []
var hidden_speech_bubbles : Array[SpeechBubble] = []

var playing := false


func reset() -> void:
    for n in speech_bubble_stack.get_children():
        speech_bubble_stack.remove_child(n)
        n.queue_free()
    shown_speech_bubbles.clear()
    hidden_speech_bubbles.clear()
    playing = false


func start_next_speech_bubble() -> void:
    if hidden_speech_bubbles.size() == 0:
        playing = false
        messages_empty.emit()
        return

    playing = true
    var speech_bubble : SpeechBubble = hidden_speech_bubbles.pop_front()

    shown_speech_bubbles.append(speech_bubble)
    # fuk
    await get_tree().process_frame
    speech_bubble.play()


func add_message(msg: String) -> void:
    var speech_bubble_instance = speech_bubble_scene.instantiate() as SpeechBubble
    speech_bubble_instance.text = msg
    hidden_speech_bubbles.append(speech_bubble_instance)
    speech_bubble_stack.add_child(speech_bubble_instance)
    speech_bubble_instance.done.connect(on_speech_bubble_done)
    if hidden_speech_bubbles.size() == 1 and not playing:
        start_next_speech_bubble()


func on_speech_bubble_done() -> void:
    var speech_bubble : SpeechBubble = shown_speech_bubbles.pop_front()
    await get_tree().create_timer(2).timeout
    start_next_speech_bubble()
    await get_tree().create_timer(5).timeout
    if is_instance_valid(speech_bubble):
        await speech_bubble.collapse()
        speech_bubble_stack.remove_child(speech_bubble)
        speech_bubble.queue_free()
