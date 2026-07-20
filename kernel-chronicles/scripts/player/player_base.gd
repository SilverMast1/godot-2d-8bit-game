class_name PlayerBase
extends CharacterBody2D

## Clase Base FSM para los personajes jugables (Bit y Byte).
## Maneja los estados: IDLE, RUN, JUMP, FALL, ATTACK, SHIELD, SPECIAL_ATTACK, HURT, DEAD.

enum State { IDLE, RUN, JUMP, FALL, ATTACK, SHIELD, SPECIAL_ATTACK, HURT, DEAD }

signal hp_changed(current_hp: int, max_hp: int)
signal energy_changed(current_energy: float, max_energy: float)
signal state_changed(new_state: State)
signal died

@export_group("Stats Base")
@export var max_hp: int = 3
@export var max_energy: float = 100.0
@export var speed: float = 150.0
@export var jump_velocity: float = -320.0
@export var acceleration: float = 1000.0
@export var friction: float = 1200.0
@export var invincibility_duration: float = 1.2
@export var shield_damage_reduction: float = 1.0 # 1.0 = 100% bloqueo

var current_state: State = State.IDLE
var current_hp: int
var current_energy: float
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 800.0)
var is_invincible: bool = false
var invincibility_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area2D = $HurtBox

func _ready() -> void:
	current_hp = max_hp
	current_energy = max_energy
	hp_changed.emit(current_hp, max_hp)
	energy_changed.emit(current_energy, max_energy)

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	handle_invincibility(delta)
	apply_gravity(delta)
	regenerate_energy(delta)

	match current_state:
		State.IDLE, State.RUN, State.JUMP, State.FALL:
			handle_movement(delta)
		State.ATTACK:
			handle_attack_state(delta)
		State.SHIELD:
			handle_shield_state(delta)
		State.SPECIAL_ATTACK:
			handle_special_attack_state(delta)
		State.HURT:
			handle_hurt_state(delta)

	move_and_slide()
	update_state_machine()
	update_animations()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func regenerate_energy(delta: float) -> void:
	if current_state != State.SPECIAL_ATTACK and current_energy < max_energy:
		current_energy = min(max_energy, current_energy + 15.0 * delta)
		energy_changed.emit(current_energy, max_energy)

func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction == 0.0:
		if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
			direction = -1.0
		elif Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
			direction = 1.0

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		if sprite:
			sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	var jump_pressed := Input.is_action_just_pressed("jump") or Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
	if jump_pressed and is_on_floor():
		perform_jump()

	if Input.is_action_just_pressed("attack") or Input.is_key_pressed(KEY_J) or Input.is_key_pressed(KEY_X):
		trigger_attack()
	elif Input.is_action_pressed("shield") or Input.is_key_pressed(KEY_K) or Input.is_key_pressed(KEY_C):
		trigger_shield()
	elif Input.is_action_just_pressed("special_attack") or Input.is_key_pressed(KEY_L) or Input.is_key_pressed(KEY_V):
		trigger_special_attack()

func perform_jump() -> void:
	velocity.y = jump_velocity
	change_state(State.JUMP)

# --- ACCIONES PRINCIPALES ---
func trigger_attack() -> void:
	change_state(State.ATTACK)
	perform_attack()

func trigger_shield() -> void:
	change_state(State.SHIELD)
	perform_shield()

func trigger_special_attack() -> void:
	if current_energy >= 30.0:
		current_energy -= 30.0
		energy_changed.emit(current_energy, max_energy)
		change_state(State.SPECIAL_ATTACK)
		perform_special_attack()

func perform_attack() -> void:
	pass

func perform_shield() -> void:
	pass

func perform_special_attack() -> void:
	pass

# --- MANEJADORES DE ESTADO EN EJECUCIÓN ---
func handle_attack_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	if animation_player and not animation_player.is_playing():
		change_state(State.IDLE)

func handle_shield_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	var shield_active := Input.is_action_pressed("shield") or Input.is_key_pressed(KEY_K) or Input.is_key_pressed(KEY_C)
	if not shield_active:
		change_state(State.IDLE)

func handle_special_attack_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	if animation_player and not animation_player.is_playing():
		change_state(State.IDLE)

func handle_hurt_state(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	if animation_player and not animation_player.is_playing():
		change_state(State.IDLE)

func handle_invincibility(delta: float) -> void:
	if is_invincible:
		invincibility_timer -= delta
		if sprite:
			sprite.modulate.a = 0.4 if int(invincibility_timer * 10) % 2 == 0 else 1.0
		if invincibility_timer <= 0.0:
			is_invincible = false
			if sprite:
				sprite.modulate.a = 1.0

func change_state(new_state: State) -> void:
	if current_state == new_state or current_state == State.DEAD:
		return
	current_state = new_state
	state_changed.emit(new_state)

func update_state_machine() -> void:
	if current_state in [State.ATTACK, State.SHIELD, State.SPECIAL_ATTACK, State.HURT, State.DEAD]:
		return

	if not is_on_floor():
		change_state(State.JUMP if velocity.y < 0 else State.FALL)
	elif abs(velocity.x) > 10.0:
		change_state(State.RUN)
	else:
		change_state(State.IDLE)

func update_animations() -> void:
	if not animation_player:
		return

	var anim_name: String = ""
	match current_state:
		State.IDLE: anim_name = "idle"
		State.RUN: anim_name = "run"
		State.JUMP: anim_name = "jump"
		State.FALL: anim_name = "fall"
		State.ATTACK: anim_name = "attack"
		State.SHIELD: anim_name = "shield"
		State.SPECIAL_ATTACK: anim_name = "special_attack"
		State.HURT: anim_name = "hurt"
		State.DEAD: anim_name = "dead"

	if anim_name != "" and animation_player.has_animation(anim_name):
		if animation_player.current_animation != anim_name:
			animation_player.play(anim_name)

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if is_invincible or current_state == State.DEAD:
		return

	if current_state == State.SHIELD:
		var final_damage = int(amount * (1.0 - shield_damage_reduction))
		if final_damage <= 0:
			return
		amount = final_damage

	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
	is_invincible = true
	invincibility_timer = invincibility_duration

	if knockback_dir != Vector2.ZERO:
		var knockback_force = 100.0 if current_state == State.SHIELD else 180.0
		velocity = knockback_dir * knockback_force

	if current_hp <= 0:
		die()
	else:
		change_state(State.HURT)

func die() -> void:
	change_state(State.DEAD)
	died.emit()
	if animation_player and animation_player.has_animation("dead"):
		animation_player.play("dead")
	else:
		queue_free()
