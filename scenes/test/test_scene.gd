extends Control


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var key_event: InputEventKey = event as InputEventKey
		var keycode_string: String = OS.get_keycode_string(key_event.keycode)
		print(keycode_string)

func _ready() -> void:
	print(Color.BISQUE.to_html())
	print(Color.DARK_RED.to_html(false))
	Color.DARK_RED
	Color.LIGHT_CORAL
	
	Color.BROWN
