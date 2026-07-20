# Especificación del Proyecto: Videojuego 2D 8-bit en Godot

## Resumen del Proyecto

**Tipo:** Videojuego 2D estilo 8-bit  
**Motor:** Godot Engine 4.x  
**Estética:** Pixel art retro 8-bit (paleta limitada, sprites de baja resolución)  
**Género base:** Plataformas / Acción 2D (adaptable)

---

## Estructura del Proyecto

```
res://
├── assets/
│   ├── sprites/
│   │   ├── player/
│   │   │   ├── player_idle.png
│   │   │   ├── player_run.png
│   │   │   ├── player_jump.png
│   │   │   └── player_death.png
│   │   ├── enemies/
│   │   ├── tiles/
│   │   └── ui/
│   ├── audio/
│   │   ├── sfx/
│   │   └── music/
│   └── fonts/
├── scenes/
│   ├── main_menu.tscn
│   ├── game.tscn
│   ├── player.tscn
│   ├── enemy.tscn
│   ├── hud.tscn
│   └── levels/
│       ├── level_01.tscn
│       └── level_02.tscn
├── scripts/
│   ├── player/
│   │   ├── player.gd
│   │   └── player_animation.gd
│   ├── enemies/
│   │   └── enemy_base.gd
│   ├── managers/
│   │   ├── game_manager.gd
│   │   ├── scene_manager.gd
│   │   └── audio_manager.gd
│   ├── ui/
│   │   └── hud.gd
│   └── world/
│       └── level_base.gd
├── resources/
│   └── data/
└── project.godot
```

---

## Sistemas Principales

### 1. Sistema de Movimiento del Jugador

**Archivo:** `scripts/player/player.gd`  
**Nodo base:** `CharacterBody2D`

Responsabilidades:
- Movimiento horizontal (izquierda/derecha) con aceleración y fricción
- Salto con gravedad variable (salto corto / largo según duración de tecla)
- Detección de suelo (`is_on_floor()`)
- Estado de doble salto (opcional)
- Dash horizontal (opcional)

Variables clave:
```gdscript
const SPEED = 120.0
const JUMP_VELOCITY = -280.0
const GRAVITY = 600.0
const ACCELERATION = 800.0
const FRICTION = 1200.0
```

Inputs mapeados en `Project > Input Map`:
- `move_left` → A / Flecha izquierda
- `move_right` → D / Flecha derecha
- `jump` → Espacio / Z
- `attack` → X / J

---

### 2. Sistema del Jugador (Player)

**Archivo:** `scripts/player/player.gd`  
**Escena:** `scenes/player.tscn`

Componentes del nodo Player:
```
Player (CharacterBody2D)
├── Sprite2D
├── AnimationPlayer
├── CollisionShape2D
├── HurtBox (Area2D)
│   └── CollisionShape2D
└── AttackBox (Area2D)
    └── CollisionShape2D
```

Máquina de estados (State Machine simple):
- `IDLE` → sin input
- `RUN` → movimiento horizontal
- `JUMP` → en el aire, velocidad positiva hacia arriba
- `FALL` → en el aire, cayendo
- `ATTACK` → animación de ataque activa
- `HURT` → recibió daño
- `DEAD` → sin vida

Atributos del jugador:
```gdscript
var max_hp: int = 3
var current_hp: int = 3
var is_invincible: bool = false
var invincibility_duration: float = 1.5
```

---

### 3. Sistema de Escena / Nivel

**Archivo:** `scripts/world/level_base.gd`  
**Escena base:** `scenes/levels/level_01.tscn`

Estructura de un nivel:
```
Level01 (Node2D)
├── TileMap          ← terreno y plataformas
├── Parallax         ← capas de fondo
├── Enemies          ← contenedor de enemigos
├── Items            ← coleccionables
├── SpawnPoint       ← posición inicial del jugador
├── ExitDoor         ← trigger para siguiente nivel
└── Camera2D         ← cámara que sigue al jugador
```

Configuración de la cámara (estilo 8-bit):
- Seguimiento suave con `position_smoothing_enabled = true`
- Límites de cámara ajustados al tamaño del nivel
- Zoom fijo (ej: `2x` o `3x` para pixeles grandes)

TileMap:
- Tile size: `16x16` px
- Usar Physics Layers para colisión
- Al menos 2 capas: `background` y `foreground`

---

### 4. Sistema de Gestión del Juego (GameManager)

**Archivo:** `scripts/managers/game_manager.gd`  
**Tipo:** Autoload (Singleton)

Responsabilidades:
- Puntuación global
- Vidas del jugador
- Estado del juego (jugando, pausado, game over)
- Señales globales: `player_died`, `level_completed`, `score_updated`

---

### 5. Sistema de Cambio de Escenas (SceneManager)

**Archivo:** `scripts/managers/scene_manager.gd`  
**Tipo:** Autoload (Singleton)

Responsabilidades:
- Transición entre escenas con fade in/out
- Carga de niveles por nombre o índice
- Reinicio del nivel actual

---

### 6. Sistema de Audio (AudioManager)

**Archivo:** `scripts/managers/audio_manager.gd`  
**Tipo:** Autoload (Singleton)

Responsabilidades:
- Reproducir SFX (salto, daño, moneda, muerte)
- Reproducir música de fondo en loop
- Control de volumen global

---

### 7. HUD (Heads Up Display)

**Archivo:** `scripts/ui/hud.gd`  
**Escena:** `scenes/hud.tscn`

Elementos UI:
- Corazones / vida del jugador (sprites 8-bit)
- Contador de puntuación
- Contador de monedas o ítems
- Indicador de nivel actual

---

## Configuración del Proyecto Godot (8-bit)

En `Project > Project Settings`:

```
Display:
  Window > Size > Viewport Width: 320
  Window > Size > Viewport Height: 180
  Window > Stretch > Mode: canvas_items
  Window > Stretch > Aspect: keep

Rendering:
  Textures > Canvas Textures > Default Texture Filter: Nearest  ← evita blur en pixel art
```

Paleta de colores recomendada: **NES** o **GameBoy** (4-8 colores base)

---

## Desglose de Tareas

### Fase 1 — Configuración del Proyecto
- [ ] **T01** Crear proyecto en Godot 4.x
- [ ] **T02** Configurar resolución y filtrado para pixel art (Nearest)
- [ ] **T03** Crear estructura de carpetas del proyecto
- [ ] **T04** Configurar Input Map (move_left, move_right, jump, attack)
- [ ] **T05** Configurar Autoloads: GameManager, SceneManager, AudioManager

### Fase 2 — Jugador y Movimiento
- [ ] **T06** Crear escena `player.tscn` con nodo CharacterBody2D
- [ ] **T07** Implementar movimiento horizontal con aceleración/fricción
- [ ] **T08** Implementar salto con gravedad y coyote time (5-6 frames)
- [ ] **T09** Crear máquina de estados básica (IDLE, RUN, JUMP, FALL)
- [ ] **T10** Integrar AnimationPlayer con sprites 8-bit del jugador
- [ ] **T11** Implementar sistema de vida y estado HURT/DEAD
- [ ] **T12** Añadir invencibilidad temporal tras recibir daño (flicker effect)

### Fase 3 — Mundo y Niveles
- [ ] **T13** Configurar TileMap con tileset 16x16
- [ ] **T14** Construir nivel de prueba (`level_01.tscn`)
- [ ] **T15** Configurar Camera2D con límites y seguimiento suave
- [ ] **T16** Agregar fondo con Parallax (1-2 capas)
- [ ] **T17** Crear trigger de salida de nivel (ExitDoor)
- [ ] **T18** Implementar punto de spawn del jugador

### Fase 4 — Enemigos
- [ ] **T19** Crear clase base `enemy_base.gd` con patrulla simple
- [ ] **T20** Implementar hitbox/hurtbox para interacción jugador-enemigo
- [ ] **T21** Crear primer enemigo (ej: slime que patrulla plataforma)
- [ ] **T22** Añadir lógica: enemigo muere al ser pisado (salto encima)

### Fase 5 — UI y Audio
- [ ] **T23** Crear HUD con corazones y puntuación
- [ ] **T24** Conectar HUD a señales del GameManager
- [ ] **T25** Crear menú principal (`main_menu.tscn`)
- [ ] **T26** Pantalla de Game Over con opción de reiniciar
- [ ] **T27** Integrar música de fondo (formato .ogg)
- [ ] **T28** Integrar efectos de sonido (salto, daño, moneda)

### Fase 6 — Pulido y Extras
- [ ] **T29** Partículas o efectos al destruir enemigos / recoger ítems
- [ ] **T30** Añadir coleccionables (monedas, power-ups)
- [ ] **T31** Implementar pausa del juego
- [ ] **T32** Transiciones de escena con fade in/out
- [ ] **T33** Ajuste de dificultad y balance del nivel 01
- [ ] **T34** Build de exportación para Windows/Web

---

## Señales Globales Sugeridas

```gdscript
# GameManager.gd
signal player_died
signal level_completed
signal score_updated(new_score: int)
signal hp_changed(new_hp: int)
```

---

## Notas de Estilo 8-bit

- Sprites máximo **16x16** o **32x32** píxeles
- Animaciones de **3 a 6 frames** por acción
- Paleta reducida: máximo **4 colores por sprite**
- Sonidos chip-tune (herramientas: **BeepBox**, **FamiTracker**, **jsfxr** para SFX)
- Sin anti-aliasing en ninguna textura (`Filter: Nearest`)

---

*Especificación generada para Godot 4.x — Proyecto 2D 8-bit*
