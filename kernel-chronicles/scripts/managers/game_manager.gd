extends Node

## GameManager: Autoload Singleton para el estado global de Kernel Chronicles.

enum CharacterType { BIT, BYTE }

signal character_selected(type: CharacterType)
signal score_updated(new_score: int)
signal game_over

var selected_character: CharacterType = CharacterType.BIT
var current_score: int = 0
var player_lives: int = 3
var is_game_paused: bool = false

func select_character(type: CharacterType) -> void:
	selected_character = type
	character_selected.emit(type)

func add_score(amount: int) -> void:
	current_score += amount
	score_updated.emit(current_score)

func reset_game_state() -> void:
	current_score = 0
	player_lives = 3
	is_game_paused = false
