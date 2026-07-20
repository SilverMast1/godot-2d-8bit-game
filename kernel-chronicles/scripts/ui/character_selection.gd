extends Control

## CharacterSelection: Controlador UI para la pantalla de selección entre Bit y Byte.
## Soporta WASD (A/D), Flechas de dirección, Enter, Espacio y gamepad.

@onready var bit_card: Control = $BitCard
@onready var byte_card: Control = $ByteCard
@onready var bit_portrait: TextureRect = $BitCard/Portrait
@onready var byte_portrait: TextureRect = $ByteCard/Portrait

var current_selection: GameManager.CharacterType = GameManager.CharacterType.BIT

func _ready() -> void:
	update_ui_highlight()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_A, KEY_LEFT, KEY_D, KEY_RIGHT:
				toggle_selection()
			KEY_ENTER, KEY_SPACE, KEY_Z, KEY_X:
				confirm_selection()
				return

	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
		toggle_selection()
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("attack"):
		confirm_selection()

func toggle_selection() -> void:
	if current_selection == GameManager.CharacterType.BIT:
		current_selection = GameManager.CharacterType.BYTE
	else:
		current_selection = GameManager.CharacterType.BIT
	update_ui_highlight()

func update_ui_highlight() -> void:
	if bit_card and byte_card:
		bit_card.modulate = Color(1.0, 1.0, 1.0, 1.0) if current_selection == GameManager.CharacterType.BIT else Color(0.35, 0.35, 0.45, 0.5)
		byte_card.modulate = Color(1.0, 1.0, 1.0, 1.0) if current_selection == GameManager.CharacterType.BYTE else Color(0.35, 0.35, 0.45, 0.5)

func confirm_selection() -> void:
	GameManager.select_character(current_selection)
	SceneManager.load_level_for_character(current_selection)
