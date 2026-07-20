class_name LevelBase
extends Node2D

## LevelBase: Controlador de nivel que conecta el HUD con el jugador spawnado.

@onready var player: PlayerBase = $PlayerBit if has_node("PlayerBit") else ($PlayerByte if has_node("PlayerByte") else null)
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	if player and hud and hud.has_method("setup_player"):
		hud.setup_player(player)
