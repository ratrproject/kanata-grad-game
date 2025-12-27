extends TextureProgressBar

@export var keyboardText : String
@export var controllerText : String

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseMotion or event is InputEventMouseButton:
		$Label.text = keyboardText
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		$Label.text = controllerText
