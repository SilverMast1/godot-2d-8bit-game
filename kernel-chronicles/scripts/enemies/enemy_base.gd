class_name EnemyBase
extends CharacterBody2D

## Clase Base extensible para enemigos (Estilo Zelda 2.5D / Plataformas).

signal enemy_died(score_value: int)

@export_group("Stats Enemigo")
@export var max_hp: int = 2
@export var speed: float = 60.0
@export var score_value: int = 100
@export var damage_on_contact: int = 1
@export var move_direction: int = -1 # -1 izq, 1 der

var current_hp: int
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity", 800.0)

@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_checker: RayCast2D = $WallChecker
@onready var floor_checker: RayCast2D = $FloorChecker

func _ready() -> void:
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	patrol_behavior(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func patrol_behavior(delta: float) -> void:
	# Detección de paredes o precipicios para cambiar dirección
	if is_on_wall() or (wall_checker and wall_checker.is_colliding()) or (floor_checker and not floor_checker.is_colliding() and is_on_floor()):
		move_direction *= -1
		if wall_checker: wall_checker.target_position.x *= -1
		if floor_checker: floor_checker.position.x *= -1

	velocity.x = move_direction * speed
	if sprite:
		sprite.flip_h = move_direction > 0

func take_damage(amount: int, knockback_dir: Vector2 = Vector2.ZERO) -> void:
	current_hp -= amount
	if knockback_dir != Vector2.ZERO:
		velocity = knockback_dir * 150.0

	if current_hp <= 0:
		die()

func die() -> void:
	enemy_died.emit(score_value)
	queue_free()
