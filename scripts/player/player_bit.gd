class_name PlayerBit
extends PlayerBase

## Personaje 'Bit': Ágil, rápido, frágil. Acción especial: Dash.

@export var can_double_jump: bool = true
@export var dash_speed_multiplier: float = 2.5
@export var dash_duration: float = 0.2

var has_double_jumped: bool = false
var is_dashing: bool = false
var dash_timer: float = 0.0

func _ready() -> void:
	max_hp = 2
	speed = 220.0
	jump_velocity = -350.0
	super._ready()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		has_double_jumped = false
	super._physics_process(delta)

# Sobreescritura de salto (Doble salto)
func perform_jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity
		change_state(State.JUMP)
	elif can_double_jump and not has_double_jumped:
		velocity.y = jump_velocity * 0.85
		has_double_jumped = true
		change_state(State.JUMP)

# Habilidad especial de Bit: Dash direccional
func primary_ability() -> void:
	is_dashing = true
	dash_timer = dash_duration
	var dash_direction = -1.0 if (sprite and sprite.flip_h) else 1.0
	velocity.x = dash_direction * speed * dash_speed_multiplier
	velocity.y = 0.0

func handle_ability_state(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0.0:
		is_dashing = false
		change_state(State.IDLE)
