class_name PlayerByte
extends PlayerBase

## Personaje 'Byte': Lento, tanque, destructivo (Alto HP, menor velocidad, rompe obstáculos).
## Analogía Java: public class PlayerByte extends PlayerBase

@export var smash_force: float = 400.0

func _ready() -> void:
	max_hp = 5
	speed = 110.0
	jump_velocity = -260.0
	super._ready()

# Sobreescritura polimórfica de habilidad especial: Golpe Pesado / Smash
func primary_ability() -> void:
	if animation_player and animation_player.has_animation("smash"):
		animation_player.play("smash")
	# Lógica para destruir bloques frágiles frente al jugador
