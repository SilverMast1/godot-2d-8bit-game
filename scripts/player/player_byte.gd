class_name PlayerByte
extends PlayerBase

## Personaje 'Byte': Tanque destructivo.
## Ataque: Heavy Smash | Escudo: Iron Guard | Especial: Seismic Quake

@export var quake_duration: float = 0.5
@export var quake_radius: float = 64.0

var is_quaking: bool = false
var quake_timer: float = 0.0

func _ready() -> void:
	max_hp = 5
	speed = 110.0
	jump_velocity = -260.0
	shield_damage_reduction = 0.85 # 85% reducción de daño + resistencia a retroceso
	super._ready()

# 1. Ataque Básico: Heavy Smash Punch
func perform_attack() -> void:
	velocity.x = 0.0

# 2. Escudo: Iron Guard (Modo Tanque Blindado)
func perform_shield() -> void:
	velocity.x = 0.0

# 3. Ataque Especial: Seismic Quake (Terremoto de área)
func perform_special_attack() -> void:
	is_quaking = true
	quake_timer = quake_duration
	velocity.x = 0.0
	if not is_on_floor():
		velocity.y = 500.0 # Caída pesada aplastante

func handle_special_attack_state(delta: float) -> void:
	quake_timer -= delta
	if quake_timer <= 0.0:
		is_quaking = false
		change_state(State.IDLE)
