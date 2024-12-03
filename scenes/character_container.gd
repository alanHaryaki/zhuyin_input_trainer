class_name CharacterContainer
extends VBoxContainer

const ZHUYIN_LABEL: PackedScene = preload("res://scenes/zhuyin_label.tscn")

@export var zhuyin_container: HBoxContainer
@export var character_label: Label

var character: String
var spelling: String


func initiate(_character: String, _spelling_override: String) -> void:
	character = _character
	
	character_label.text = character
	
	spelling = _spelling_override if _spelling_override else Global.character_zhuyin_dictionary[character][0]
	
	spelling += " " if spelling[-1] not in [" ", "ˇ", "ˋ", "ˊ", "˙"] else ""

	for sign: String in spelling.split():
		var zhuyin_label: Label = ZHUYIN_LABEL.instantiate()
		zhuyin_label.text = sign if sign != " " else "‾"
		zhuyin_container.add_child(zhuyin_label)
