class_name CharacterContainer
extends VBoxContainer

const ZHUYIN_LABEL: PackedScene = preload("res://scenes/zhuyin_label.tscn")

@export var zhuyin_container: HBoxContainer
@export var character_label: Label

var character: String


func initiate(_character: String) -> void:
	character = _character
	
	character_label.text = character

	var zhuyin: String = Global.character_zhuyin_dictionary[character][0]

	for sign: String in zhuyin.split():
		var zhuyin_label: Label = ZHUYIN_LABEL.instantiate()
		zhuyin_label.text = sign if sign != " " else "-"
		zhuyin_container.add_child(zhuyin_label)
