extends Control

## CharacterSelection: Controlador UI de pantalla completa split-screen para Bit y Byte.
## Garantiza lectura inmediata de Flechas, WASD (A/D), Espacio y Enter.

@onready var bit_card: Control = $BitCard
@onready var byte_card: Control = $ByteCard

var current_selection: GameManager.CharacterType = GameManager.CharacterType.BIT
var can_input: bool = true

func _ready() -> void:
	# Asegurar que ningún nodo hijo intercepte el foco del teclado
	focus_mode = FOCUS_ALL
	grab_focus()
	update_ui_highlight()

func _process(_delta: float) -> void:
	if not can_input:
		return

	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") \
	or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		toggle_selection()
	elif Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("attack"):
		confirm_selection()

func _input(event: InputEvent) -> void:
	if not can_input:
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
	if current_selection == GameManager.CharacterType.BIT:
		current_selection = GameManager.CharacterType.BYTE
	else:
		current_selection = GameManager.CharacterType.BIT
	update_ui_highlight()

func update_ui_highlight() -> void:
	if bit_card and byte_card:
		if current_selection == GameManager.CharacterType.BIT:
			bit_card.modulate = Color(1.0, 1.0, 1.0, 1.0)
			byte_card.modulate = Color(0.25, 0.25, 0.35, 0.5)
		else:
			bit_card.modulate = Color(0.25, 0.25, 0.35, 0.5)
			byte_card.modulate = Color(1.0, 1.0, 1.0, 1.0)

func confirm_selection() -> void:
	can_input = false
	GameManager.select_character(current_selection)
	SceneManager.load_level_for_character(current_selection)
