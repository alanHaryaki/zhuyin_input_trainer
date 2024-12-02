extends Node


enum KeyCategory {
	聲母,
	韻母,
	介母,
	聲調,
}


enum ColorMode {
	BRIGHT,
	DARK,
	BY_CATEGORY,
}


var texts: Array
var character_zhuyin_dictionary: Dictionary


func load_data() -> void:
	texts = read_json_file("res://resources/texts.json") as Array
	character_zhuyin_dictionary = read_json_file("res://resources/character_zhuyin_dictionary.json") as Dictionary


func read_json_file(file_path: String) -> Variant:
	var json_file = FileAccess.open(file_path, FileAccess.READ)
	var data: Variant = JSON.parse_string(json_file.get_as_text())
	
	return data
