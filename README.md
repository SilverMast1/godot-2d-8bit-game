# Videojuego 2D 8-Bit en Godot Engine 4.x

Este repositorio contiene la especificación, arquitectura y plan de tareas para el desarrollo de un videojuego de plataformas/acción estilo retro 8-bit desarrollado con Godot 4.x.

## 📌 Documentación y Arquitectura

Puedes consultar la arquitectura detallada del juego y el plan de desarrollo paso a paso en:
- [Especificación del Proyecto (Arquitectura y Tasklist)](.kiro/specs/game_architecture.md)

## 🎮 Características Principales

- **Motor:** Godot Engine 4.x
- **Estética:** Pixel Art 8-bit (Viewport 320x180, Nearest filtering)
- **Sistemas:**
  - Controlador de Jugador (CharacterBody2D) con máquina de estados simple.
  - Gestión centralizada de estado (`GameManager`), audio (`AudioManager`) y escenas (`SceneManager`).
  - TileMaps 16x16 px con capas de Parallax.
  - Enemigos base con hitboxes/hurtboxes.
  - HUD retro y efectos Chip-tune.

## 🚀 Inicio Rápido

1. Clona este repositorio:
   ```bash
   git clone https://github.com/SilverMast1/godot-2d-8bit-game.git
   ```
2. Abre **Godot Engine 4.x** e importa el proyecto.
3. Revisa el archivo `.kiro/specs/game_architecture.md` para consultar las tareas pendientes.
