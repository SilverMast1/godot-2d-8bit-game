extends Control

## CharacterSelection: Controlador UI para la pantalla de selección entre Bit y Byte.

@onready var bit_card: Control = $BitCard
@onready var byte_card: Control = $ByteCard
@onready var bit_portrait: TextureRect = $BitCard/Portrait
@onready var byte_portrait: TextureRect = $ByteCard/Portrait

var current_selection: GameManager.CharacterType = GameManager.CharacterType.BIT

func _ready() -> void:
	update_ui_highlight()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") or event.is_action_pressed("move_right"):
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
		bit_card.modulate = Color(1.0, 1.0, 1.0, 1.0) if current_selection == GameManager.CharacterType.BIT else Color(0.5, 0.5, 0.5, 0.7)
		byte_card.modulate = Color(1.0, 1.0, 1.0, 1.0) if current_selection == GameManager.CharacterType.BYTE else Color(0.5, 0.5, 0.5, 0.7)

func confirm_selection() -> void:
	GameManager.select_character(current_selection)
	SceneManager.load_level_for_character(current_selection)
