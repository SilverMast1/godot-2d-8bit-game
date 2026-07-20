extends Control

## CharacterSelection: Controlador UI split-screen simple y libre de errores.

@onready var bit_card: Control = $BitCard
@onready var byte_card: Control = $ByteCard

var current_selection: int = 0 # 0 = BIT, 1 = BYTE
var is_confirming: bool = false

func _ready() -> void:
	update_ui_highlight()

func _input(event: InputEvent) -> void:
	if is_confirming:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_LEFT, KEY_RIGHT, KEY_A, KEY_D:
				toggle_selection()
				get_viewport().set_input_as_handled()
			KEY_ENTER, KEY_KP_ENTER, KEY_SPACE, KEY_Z, KEY_X:
				confirm_selection()
				get_viewport().set_input_as_handled()

func toggle_selection() -> void:
	current_selection = 1 - current_selection
	update_ui_highlight()

func update_ui_highlight() -> void:
	if bit_card and byte_card:
		if current_selection == 0: # BIT
			bit_card.modulate = Color(1.0, 1.0, 1.0, 1.0)
			byte_card.modulate = Color(0.25, 0.25, 0.35, 0.5)
		else: # BYTE
			bit_card.modulate = Color(0.25, 0.25, 0.35, 0.5)
			byte_card.modulate = Color(1.0, 1.0, 1.0, 1.0)

func confirm_selection() -> void:
	if is_confirming:
		return
	is_confirming = true
	if GameManager:
		GameManager.select_character(current_selection)
	if SceneManager:
		SceneManager.load_level_for_character(current_selection)
