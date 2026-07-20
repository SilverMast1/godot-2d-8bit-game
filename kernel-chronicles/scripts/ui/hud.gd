extends CanvasLayer

## HUD Controller: Administra los corazones de HP, barra de energía y contador de Score.

@onready var hp_label: Label = $MarginContainer/VBoxContainer/HPLabel
@onready var energy_bar: TextureProgressBar = $MarginContainer/VBoxContainer/EnergyBar
@onready var score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

func _ready() -> void:
	if GameManager:
		GameManager.score_updated.connect(_on_score_updated)
		_on_score_updated(GameManager.current_score)

func setup_player(player: PlayerBase) -> void:
	if player:
		player.hp_changed.connect(_on_hp_changed)
		player.energy_changed.connect(_on_energy_changed)
		_on_hp_changed(player.current_hp, player.max_hp)
		_on_energy_changed(player.current_energy, player.max_energy)

func _on_hp_changed(current_hp: int, max_hp: int) -> void:
	if hp_label:
		hp_label.text = "HP: " + str(current_hp) + "/" + str(max_hp)

func _on_energy_changed(current_energy: float, max_energy: float) -> void:
	if energy_bar:
		energy_bar.max_value = max_energy
		energy_bar.value = current_energy

func _on_score_updated(new_score: int) -> void:
	if score_label:
		score_label.text = "SCORE: " + str(new_score)
