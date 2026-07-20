class_name PlayerBit
extends PlayerBase

## Personaje 'Bit': Ágil, rápido, frágil (HP reducido, doble salto, mayor velocidad).
## Analogía Java: public class PlayerBit extends PlayerBase

@export var can_double_jump: bool = true
var has_double_jumped: bool = false

func _ready() -> void:
	max_hp = 2
	speed = 220.0
	jump_velocity = -350.0
	super._ready()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		has_double_jumped = false
	super._physics_process(delta)

# Sobreescritura polimórfica del salto (Doble Salto)
func perform_jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity
	elif can_double_jump and not has_double_jumped:
		velocity.y = jump_velocity * 0.85
		has_double_jumped = true

# Sobreescritura polimórfica de habilidad especial: Dash Rápido
func primary_ability() -> void:
	var dash_direction = -1.0 if (sprite and sprite.flip_h) else 1.0
	velocity.x = dash_direction * speed * 2.5
