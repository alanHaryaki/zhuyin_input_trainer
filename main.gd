extends Control

const CHARACTER_CONTAINER: PackedScene = preload("res://scenes/character_container.tscn")

@export var text_container: HBoxContainer

var show_pinyin: bool = false:
	set = set_global_pinyin_visibility

var show_key: bool = false:
	set = set_global_key_visibility


var current_text_index: int = 0
var current_string: String = ""
var current_character_index: int = 0

@onready var positive_notification: AudioStreamPlayer = $PositiveNotification


func _ready() -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.button_matched.connect(on_button_matched)
	
	Global.load_data()
	
	display_text(current_text_index)
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event: InputEventKey = event as InputEventKey
		var keycode_string: String = OS.get_keycode_string(key_event.keycode)

		if keycode_string == "F1":
			change_color_mode(Global.ColorMode.BRIGHT)
		elif keycode_string == "F2":
			change_color_mode(Global.ColorMode.DARK)
		elif keycode_string == "F3":
			change_color_mode(Global.ColorMode.BY_CATEGORY)
		elif keycode_string == "F4":
			show_pinyin = not show_pinyin
		elif keycode_string == "F5":
			show_key = not show_key
		else:
			pass
			#highlight_key(keycode_string)


func display_text(text_index: int) -> void:
	for child: Control in text_container.get_children():
		child.queue_free()
	var text: String = Global.texts[text_index]
	for character: String in text.split():
		var character_container: CharacterContainer = CHARACTER_CONTAINER.instantiate()
		character_container.initiate(character)
		text_container.add_child(character_container)


func on_button_matched(button: KeyButton) -> void:
	if not current_string or current_string[-1] != button.zhuyin:
		current_string += button.zhuyin
	
	print(current_string)
	
	check_input()


func check_input() -> void:
	for child in text_container.get_children()[current_character_index].zhuyin_container.get_children():
		child.modulate = Color.WHITE
	for i: int in range(min(Global.character_zhuyin_dictionary[Global.texts[current_text_index][current_character_index]][0].length(), current_string.length()), 0, -1):
		
		print("Comparing ", current_string.right(i), " and ", Global.character_zhuyin_dictionary[Global.texts[current_text_index][current_character_index]][0].left(i))
		if current_string.right(i) == Global.character_zhuyin_dictionary[Global.texts[current_text_index][current_character_index]][0].left(i):
			for index: int in range(i):
				text_container.get_children()[current_character_index].zhuyin_container.get_children()[index].modulate = Color.SEA_GREEN
			break
	
	if Global.character_zhuyin_dictionary[Global.texts[current_text_index][current_character_index]].any(func(zhuyin): return zhuyin in current_string):
		
		positive_notification.play()
		
		current_string = ""

		for child in text_container.get_children()[current_character_index].zhuyin_container.get_children():
			child.modulate = Color.WHITE
		
		text_container.get_children()[current_character_index].modulate = Color.SEA_GREEN
		
		current_character_index += 1
		
		if current_character_index >= Global.texts[current_text_index].length():
			current_character_index = 0
			current_text_index += 1
			current_text_index = current_text_index % Global.texts.size()
			
			display_text(current_text_index)


func set_global_pinyin_visibility(_show_pinyin: bool) -> void:
	show_pinyin = _show_pinyin
	
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.show_pinyin = show_pinyin


func set_global_key_visibility(_show_key: bool) ->  void:
	show_key = _show_key
	
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.show_key = show_key


func change_color_mode(_mode: Global.ColorMode) -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		key_button.color_mode = _mode


# No longer in use
func highlight_key(_keycode_string) -> void:
	for key_button: KeyButton in get_tree().get_nodes_in_group("key button"):
		if key_button.key == _keycode_string:
			print("key pressed")
			key_button.button_pressed = true
