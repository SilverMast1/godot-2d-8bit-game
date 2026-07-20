class_name PlayerBit
extends PlayerBase

## Personaje 'Bit': Ágil y rápido.
## Ataque: Cyber Slash | Escudo: Holo Shield (Parry) | Especial: Overclock Blitz

@export var can_double_jump: bool = true
@export var dash_speed_multiplier: float = 2.5
@export var special_blitz_speed: float = 400.0

var has_double_jumped: bool = false
var is_blitzing: bool = false
var blitz_timer: float = 0.0

func _ready() -> void:
	max_hp = 2
	speed = 220.0
	jump_velocity = -350.0
	shield_damage_reduction = 1.0 # 100% Bloqueo / Parry perfecto
	super._ready()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		has_double_jumped = false
	super._physics_process(delta)

# Sobreescritura de salto (Doble Salto)
func perform_jump() -> void:
	if is_on_floor():
		velocity.y = jump_velocity
		change_state(State.JUMP)
	elif can_double_jump and not has_double_jumped:
		velocity.y = jump_velocity * 0.85
		has_double_jumped = true
		change_state(State.JUMP)

# 1. Ataque Básico: Cyber Slash
func perform_attack() -> void:
	# Lógica visual o hitbox de ataque de sable rápido
	velocity.x *= 0.5

# 2. Escudo: Holo Shield
func perform_shield() -> void:
	# Despliega escudo de energía azul
	velocity.x = 0.0

# 3. Ataque Especial: Overclock Blitz
func perform_special_attack() -> void:
	is_blitzing = true
	blitz_timer = 0.3
	var dir = -1.0 if (sprite and sprite.flip_h) else 1.0
	velocity.x = dir * special_blitz_speed
	velocity.y = 0.0

func handle_special_attack_state(delta: float) -> void:
	blitz_timer -= delta
	if blitz_timer <= 0.0:
		is_blitzing = false
		change_state(State.IDLE)
