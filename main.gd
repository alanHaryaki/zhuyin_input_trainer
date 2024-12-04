extends Control

const CHARACTER_CONTAINER: PackedScene = preload("res://scenes/character_container.tscn")

@export var text_container: HBoxContainer

var show_pinyin: bool = false:
	set = set_global_pinyin_visibility

var show_key: bool = false:
	set = set_global_key_visibility

var sound_effects_enabled: bool = true


var current_string: String = ""
var current_section_index: int = 0 # Currently not in use. Saved for future use.
var current_text_index: int = 0
var current_sentence_index: int = 0
var current_character_index: int = 0

@onready var key_board: Control = $KeyBoard
@onready var positive_notification: AudioStreamPlayer = $PositiveNotification
@onready var neutral_notification: AudioStreamPlayer = $NeutralNotification
@onready var author_label: Label = $InfoContainer/AuthorLabel
@onready var title_label: Label = $InfoContainer/TitleLabel
@onready var note_label: Label = $InfoContainer/NoteLabel



func _ready() -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.button_matched.connect(on_button_matched)
	
	Global.load_data()
	
	display_text(current_text_index, current_sentence_index)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event: InputEventKey = event as InputEventKey
		var keycode_string: String = OS.get_keycode_string(key_event.keycode)

		if keycode_string == "F1":
			change_color_mode()
		elif keycode_string == "F2":
			show_pinyin = not show_pinyin
		elif keycode_string == "F3":
			show_key = not show_key
		elif keycode_string == "F4":
			key_board.visible = not key_board.visible
			if key_board.visible:
				text_container.position = Vector2(0, 280)
			else:
				text_container.position.y = 500
		elif keycode_string == "F5":
			sound_effects_enabled = not sound_effects_enabled
			if not sound_effects_enabled:
				neutral_notification.play()
		elif keycode_string == "F6":
			current_sentence_index = 0
			current_text_index = (current_text_index + randi_range(1, Global.texts.size())) % Global.texts.size()
			
			display_text(current_text_index, current_sentence_index)
		else:
			return
		
		if sound_effects_enabled:
			neutral_notification.play()


func display_text(text_index: int, sentence_index: int) -> void:
	for child: Control in text_container.get_children():
		child.queue_free()
	var text: String = Global.texts[text_index]["sentences"][sentence_index]["text"]
	var note: String = Global.texts[text_index]["sentences"][sentence_index]["note"] if Global.texts[text_index]["sentences"][sentence_index].has("note") else ""
	title_label.text = Global.texts[text_index]["info"]["title"]
	author_label.text = Global.texts[text_index]["info"]["author"]
	note_label.text = note
	var spelling_overrides: Dictionary = Global.texts[text_index]["sentences"][sentence_index]["spelling_overrides"] \
		if Global.texts[text_index]["sentences"][sentence_index].has("spelling_overrides") else {}
	for i: int in text.length():
		var character_container: CharacterContainer = CHARACTER_CONTAINER.instantiate()
		var spelling_override: String = "" if not spelling_overrides or not spelling_overrides.has(str(i)) else spelling_overrides[str(i)]
		character_container.initiate(text[i], spelling_override)
		text_container.add_child(character_container)


func on_button_matched(button: KeyButton) -> void:
	if not current_string or current_string[-1] != button.zhuyin:
		current_string += button.zhuyin
	
	print(current_string)
	
	check_input()


func check_input() -> void:
	for child in text_container.get_children()[current_character_index].zhuyin_container.get_children():
		child.modulate = Color.WHITE
	
	var current_character_container: CharacterContainer = text_container.get_children()[current_character_index]
	
	var correct_spelling: String = current_character_container.spelling
	
	for i: int in range(min(correct_spelling.length(), current_string.length()), 0, -1):
		
		print("Comparing ", current_string.right(i), " and ", correct_spelling.left(i))
		
		if current_string.right(i) == correct_spelling.left(i):
			for index: int in range(i):
				current_character_container.zhuyin_container.get_children()[index].modulate = Color.SEA_GREEN
			break
	
	if correct_spelling in current_string:
		
		if sound_effects_enabled:
			positive_notification.play()
		
		current_string = ""

		for child in current_character_container.zhuyin_container.get_children():
			child.modulate = Color.WHITE
		
		current_character_container.modulate = Color.SEA_GREEN
		
		current_character_index += 1
		
		if current_character_index >= Global.texts[current_text_index]["sentences"][current_sentence_index]["text"].length():
			current_character_index = 0
			current_sentence_index += 1
			
			if current_sentence_index >= Global.texts[current_text_index]["sentences"].size():
				current_sentence_index = 0
				current_text_index = (current_text_index + 1) % Global.texts.size()
			
			display_text(current_text_index, current_sentence_index)


func set_global_pinyin_visibility(_show_pinyin: bool) -> void:
	show_pinyin = _show_pinyin
	
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.show_pinyin = show_pinyin


func set_global_key_visibility(_show_key: bool) ->  void:
	show_key = _show_key
	
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.show_key = show_key


func change_color_mode() -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.color_mode = (key_button.color_mode + 1) % 3


# No longer in use
func highlight_key(_keycode_string) -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		if key_button.key == _keycode_string:
			print("key pressed")
			key_button.button_pressed = true
