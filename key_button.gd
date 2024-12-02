@tool

class_name KeyButton
extends Button

signal button_matched(key_button: KeyButton)

@export_group("Set Up")
@export var zhuyin: String: 
	set = set_zhuyin
@export var category: Global.KeyCategory
@export var pinyin: String:
	set = set_pinyin
@export var key: String:
	set = set_key
@export var color_mode: Global.ColorMode = Global.ColorMode.BRIGHT:
	set = set_color_mode
@export var show_pinyin: bool = false:
	set = set_pinyin_visibility
@export var show_key: bool = false:
	set = set_key_visibility
@export var audio_stream: AudioStream

@export_group("Components")
@export var pinyin_label: Label
@export var key_label: Label
@export var audio_player: AudioStreamPlayer


func _ready() -> void:
	add_to_group("key button")
	
	audio_player.stream = audio_stream


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if OS.get_keycode_string(event.keycode) == self.key:
			if event.is_pressed():
				self.button_pressed = true
				audio_player.play()
			elif event.is_released():
				self.set_pressed_no_signal(false)
				button_matched.emit(self)


func set_zhuyin(_zhuyin: String):
	zhuyin = _zhuyin
	
	text = zhuyin


func set_pinyin(_pinyin: String):
	pinyin = _pinyin
	pinyin_label.text = pinyin


func set_pinyin_visibility(_show_pinyin: bool) -> void:
	show_pinyin = _show_pinyin
	
	if show_pinyin:
		pinyin_label.show()
	else:
		pinyin_label.hide()


func set_key(_key: String) -> void:
	key = _key

	key_label.text = get_sign(key)


func get_sign(_key: String) -> String:
	match _key:
		"Comma":
			return ","
		"Period":
			return "."
		"Slash":
			return "/"
		"Semicolon":
			return ";"
		"Minus":
			return "-"
		_:
			return _key
	


func set_key_visibility(_show_key: bool) -> void:
	show_key = _show_key
	
	if show_key:
		key_label.show()
	else:
		key_label.hide()


func set_color_mode(_mode: Global.ColorMode) -> void:
	color_mode = _mode
	
	match color_mode:
		Global.ColorMode.DARK:
			self.set_theme_type_variation("KeyButtonDarkMode")
			pinyin_label.get_label_settings().font_color = Color.WHITE
			pinyin_label.get_label_settings().outline_color = Color.BLACK
			
			self.modulate = Color.WHITE
			
		Global.ColorMode.BRIGHT:
			self.set_theme_type_variation("KeyButtonBrightMode")
			pinyin_label.get_label_settings().font_color = Color.BLACK
			pinyin_label.get_label_settings().outline_color = Color.WHITE
			
			self.modulate = Color.WHITE
			
		Global.ColorMode.BY_CATEGORY:
			self.set_theme_type_variation("KeyButtonBrightMode")
			pinyin_label.get_label_settings().font_color = Color.BLACK
			pinyin_label.get_label_settings().outline_color = Color.WHITE
			
			match category:
				Global.KeyCategory.聲母:
					self.modulate = Color.AQUAMARINE
				Global.KeyCategory.韻母:
					self.modulate = Color.BROWN
				Global.KeyCategory.介母:
					self.modulate = Color.DARK_SEA_GREEN
				Global.KeyCategory.聲調:
					self.modulate = Color.BURLYWOOD
	

func _on_toggled(toggled_on: bool) -> void:
	pass
	"""print("button toggled")
	await get_tree().create_timer(0.1).timeout
	self.set_pressed_no_signal(false)
"""
