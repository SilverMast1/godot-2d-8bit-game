extends Node

## SceneManager: Autoload Singleton para transiciones y enrutamiento dinámico de escenas.

const BIT_LEVEL_PATH: String = "res://scenes/levels/level_01_bit.tscn"
const BYTE_LEVEL_PATH: String = "res://scenes/levels/level_01_byte.tscn"
const MAIN_MENU_PATH: String = "res://scenes/ui/main_menu.tscn"
const CHAR_SELECT_PATH: String = "res://scenes/ui/character_selection.tscn"

func load_level_for_character(character_type: int) -> void:
	match character_type:
		0: # BIT
			change_scene_to(BIT_LEVEL_PATH)
		1: # BYTE
			change_scene_to(BYTE_LEVEL_PATH)

func change_scene_to(target_path: String) -> void:
	if ResourceLoader.exists(target_path):
		get_tree().call_deferred("change_scene_to_file", target_path)
	else:
		push_warning("La escena no existe aún en la ruta: " + target_path)

func reload_current_scene() -> void:
	get_tree().call_deferred("reload_current_scene")
