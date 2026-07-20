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

### Fase 1 — Configuración del Proyecto y Entorno
- [ ] **T01** Crear proyecto base en Godot 4.x
- [ ] **T02** Configurar resolución retro (320x180), estiramiento canvas_items y filtrado pixel art (Nearest)
- [ ] **T03** Crear estructura de carpetas del proyecto (`assets/`, `scenes/`, `scripts/`, `resources/`)
- [ ] **T04** Configurar Input Map con soporte para Teclado y Gamepad/Joystick (move_left, move_right, jump, attack)
- [ ] **T05** Configurar Autoloads principales: `GameManager`, `SceneManager`, `AudioManager`, `SaveManager`

### Fase 2 — Jugador y Mecánicas de Movimiento
- [ ] **T06** Crear escena `player.tscn` con nodo `CharacterBody2D`, `CollisionShape2D` y `Sprite2D`
- [ ] **T07** Implementar movimiento horizontal con física personalizable (aceleración, fricción, velocidad máx)
- [ ] **T08** Implementar salto variable por duración de tecla, gravedad y Coyote Time (5-6 frames) + Jump Buffering
- [ ] **T09** Crear máquina de estados finitos (FSM) para el jugador (IDLE, RUN, JUMP, FALL, ATTACK, HURT, DEAD)
- [ ] **T10** Configurar `AnimationPlayer` y animaciones de sprites 8-bit (Idle, Run, Jump, Fall, Hurt)
- [ ] **T11** Implementar sistema de HP del jugador y lógica de daño en Hurtbox
- [ ] **T12** Añadir invencibilidad temporal tras recibir daño con efecto parpadeo (flicker) y Knockback

### Fase 3 — Sistema de Combate y Proyectiles
- [ ] **T13** Implementar área de ataque melee (`AttackBox`) con activación por frame en animaciones
- [ ] **T14** Implementar soporte para ataques con proyectiles 8-bit (opcional para jugador o enemigos)
- [ ] **T15** Añadir mecánica de rebote al pisar enemigos (Pogo Jump / Stomp Mechanic)

### Fase 4 — Mundo, Niveles y Checkpoints
- [ ] **T16** Configurar `TileMap` / `TileMapLayer` en Godot 4 con colisiones 16x16 px
- [ ] **T17** Construir nivel de pruebas `level_01.tscn` con plataformas, obstáculos y zonas de peligro (Hazard Zones / Spikes)
- [ ] **T18** Configurar `Camera2D` con límites de nivel, seguimiento suave y zonas muertas (Dead Zones)
- [ ] **T19** Crear sistema de Parallax Background (1-3 capas con velocidad diferencial)
- [ ] **T20** Implementar sistema de Checkpoints mid-level (banderas/faroles) y Respawn Point
- [ ] **T21** Crear disparador de fin de nivel (`ExitDoor`) para cargar el siguiente mapa

### Fase 5 — Enemigos e IA Base
- [ ] **T22** Crear clase base extensible `enemy_base.gd` con patrulla horizontal y colisión con paredes/bordes
- [ ] **T23** Configurar Hitbox y Hurtbox en enemigos para detección de daño bilateral
- [ ] **T24** Crear variantes de enemigos (ej: Slime de patrulla terrestre, Murciélago volador simple)
- [ ] **T25** Añadir efectos de muerte de enemigos (animación de destrucción, feedback visual y sfx)

### Fase 6 — UI, Audio y Persistencia
- [ ] **T26** Diseñar HUD retro con representación visual de corazones, score e indicador de nivel
- [ ] **T27** Conectar señales de `GameManager` al HUD (`hp_changed`, `score_updated`)
- [ ] **T28** Crear pantalla de Menú Principal (`main_menu.tscn`) y Menú de Pausa en partida
- [ ] **T29** Implementar `SaveManager` para guardar/cargar récord de puntuación, nivel alcanzado y ajustes en `user://savegame.json`
- [ ] **T30** Integrar reproductor de música chip-tune en loop (`AudioManager`)
- [ ] **T31** Implementar buses de audio (Master, BGM, SFX) con control de volumen en la UI

### Fase 7 — Game Juice, Pulido y CI/CD
- [ ] **T32** Agregar Screen Shake (sacudida de cámara) en impactos fuertes o explosiones
- [ ] **T33** Agregar efectos de Squash & Stretch en los saltos y aterrizajes del jugador
- [ ] **T34** Implementar partículas retro CPUParticles2D (polvo al correr/saltar, destellos al recolectar monedas)
- [ ] **T35** Transiciones de pantalla entre niveles con efecto Fade-In / Fade-Out y Wipes retro
- [ ] **T36** Configurar flujo de CI/CD con GitHub Actions para validación de código y exportación automática a HTML5 / Web y Executable Windows


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
