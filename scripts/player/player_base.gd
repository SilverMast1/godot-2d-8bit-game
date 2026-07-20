class_name PlayerBase
extends CharacterBody2D

## Clase Base FSM para los personajes jugables (Bit y Byte).

enum State { IDLE, RUN, JUMP, FALL, ABILITY, HURT, DEAD }

signal hp_changed(current_hp: int, max_hp: int)
signal state_changed(new_state: State)
signal died

@export_group("Stats Base")
@export var max_hp: int = 3
@export var speed: float = 150.0
@export var jump_velocity: float = -320.0
@export var acceleration: float = 1000.0
@export var friction: float = 1200.0
@export var invincibility_duration: float = 1.2

var current_state: State = State.IDLE
var current_hp: int
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 800.0)
var is_invincible: bool = false
var invincibility_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area2D = $HurtBox

func _ready() -> void:
	current_hp = max_hp
	hp_changed.emit(current_hp, max_hp)

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	handle_invincibility(delta)
	apply_gravity(delta)

	match current_state:
		State.IDLE, State.RUN, State.JUMP, State.FALL:
			handle_movement(delta)
		State.ABILITY:
			handle_ability_state(delta)
		State.HURT:
			handle_hurt_state(delta)

	move_and_slide()
	update_state_machine()
	update_animations()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		if sprite:
			sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		perform_jump()

	if Input.is_action_just_pressed("attack"):
		trigger_primary_ability()

func perform_jump() -> void:
	velocity.y = jump_velocity
	change_state(State.JUMP)

func trigger_primary_ability() -> void:
	change_state(State.ABILITY)
	primary_ability()

## Método polimórfico a sobreescribir por subclases (Bit / Byte)
func primary_ability() -> void:
	pass

func handle_ability_state(_delta: float) -> void:
	# Retornar a IDLE cuando termina la animación o acción
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
	if current_state in [State.ABILITY, State.HURT, State.DEAD]:
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

	match current_state:
		State.IDLE:
			animation_player.play("idle")
		State.RUN:
			animation_player.play("run")
		State.JUMP:
			animation_player.play("jump")
		State.FALL:
			animation_player.play("fall")
		State.ABILITY:
			if animation_player.has_animation("ability"):
				animation_player.play("ability")
		State.HURT:
			if animation_player.has_animation("hurt"):
				animation_player.play("hurt")
		State.DEAD:
			if animation_player.has_animation("dead"):
				animation_player.play("dead")

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if is_invincible or current_state == State.DEAD:
		return

	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
	is_invincible = true
	invincibility_timer = invincibility_duration

	if knockback_dir != Vector2.ZERO:
		velocity = knockback_dir * 180.0

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
