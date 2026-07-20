class_name PlayerBase
extends CharacterBody2D

## Clase Base abstracta para los personajes jugables (Bit y Byte).
## Analogía Java: public abstract class PlayerBase extends CharacterBody2D

# Señales (Equivalente al Observer Pattern / Event Listeners)
signal hp_changed(current_hp: int, max_hp: int)
signal died

# Atributos de Stats (Visibles en el inspector mediante @export)
@export_group("Stats Base")
@export var max_hp: int = 3
@export var speed: float = 150.0
@export var jump_velocity: float = -320.0
@export var acceleration: float = 1000.0
@export var friction: float = 1200.0

var current_hp: int
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 800.0)
var is_invincible: bool = false

# Inyección de dependencias de Nodos Hijos (@onready)
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurtbox: Area2D = $HurtBox

func _ready() -> void:
	current_hp = max_hp
	hp_changed.emit(current_hp, max_hp)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement(delta)
	move_and_slide()
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
		primary_ability()

func perform_jump() -> void:
	velocity.y = jump_velocity

## Método Polimórfico / Virtual (Para sobreescribir en subclases Bit/Byte)
func primary_ability() -> void:
	pass

func update_animations() -> void:
	if not animation_player:
		return
	if not is_on_floor():
		animation_player.play("jump" if velocity.y < 0 else "fall")
	elif abs(velocity.x) > 10.0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func take_damage(amount: int) -> void:
	if is_invincible or current_hp <= 0:
		return
	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		die()

func die() -> void:
	died.emit()
	queue_free()
