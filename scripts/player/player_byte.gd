class_name PlayerByte
extends PlayerBase

## Personaje 'Byte': Tanque destructivo. Acción especial: Ground Smash.

@export var smash_duration: float = 0.4
@export var smash_radius: float = 32.0

var is_smashing: bool = false
var smash_timer: float = 0.0

func _ready() -> void:
	max_hp = 5
	speed = 110.0
	jump_velocity = -260.0
	super._ready()

# Habilidad especial de Byte: Ground Smash
func primary_ability() -> void:
	is_smashing = true
	smash_timer = smash_duration
	velocity.x = 0.0
	if not is_on_floor():
		velocity.y = 400.0 # Caída pesada si está en el aire

func handle_ability_state(delta: float) -> void:
	smash_timer -= delta
	if smash_timer <= 0.0:
		is_smashing = false
		change_state(State.IDLE)
