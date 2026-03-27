# hus-rpg-beta

A turn-based RPG prototype built with [Godot 4](https://godotengine.org/) (version 4.6, Forward Plus renderer).

## Overview

**hus-rpg-beta** is a tactical RPG featuring hex-grid battle maps, a side-scrolling world, an inventory/equipment system, and a variety of playable and enemy units with unique abilities.

## Features

- **Hex-grid battle system** — tactical combat played on a hexagonal grid with turn and round management
- **Multiple unit types** — Viking, Archer, Wizard, Necromancer, Skeleton Archer, Skull, and more
- **Ability system** — melee attacks, bow shots, fireballs, movement, and projectile abilities
- **Inventory & equipment** — pick up, equip, and unequip items via an in-game inventory UI
- **World map & side-scroll levels** — navigate between a hex world map and side-scrolling areas
- **Audio control** — in-game audio options panel
- **Save / load** — quick save (`F5`) and quick load (`F9`) support

## Controls

| Action | Key / Button |
|---|---|
| Move | W / A / S / D |
| Select ability 1–4 | 1 / 2 / 3 / 4 |
| End turn | Space |
| Toggle inventory | V |
| Equip item | Right-click |
| Quick save | F5 |
| Quick load | F10 |
| Toggle test panel | F11 |

## Project Structure

```
hus-rpg-beta/
├── addons/          # Third-party Godot addons (hex grid nav, GDScript formatter)
├── assets/          # Art, audio, and other raw assets
├── resources/       # Godot resource files (units, equipment, tilesets, themes)
│   ├── equipments/
│   ├── sprite_frames/
│   ├── themes/
│   └── units/
├── scenes/          # All game scenes and GDScript source files
│   ├── abilities/   # Ability scenes and logic
│   ├── audios/      # Audio players
│   ├── autoloads/   # Global singletons (managers for battle, turns, inventory, camera, scene changes)
│   ├── effects/     # Visual effects
│   ├── equipments/  # Equipment scenes
│   ├── general/     # Shared/general scenes
│   ├── levels/      # Battle, world, and side-scroll level scenes
│   ├── shaders/     # GLSL shaders
│   ├── ui/          # All UI scenes (menus, HUD, panels)
│   ├── units/       # Unit scenes
│   ├── utils/       # Utility scripts
│   └── weapons/     # Weapon scenes
└── project.godot    # Godot project configuration
```

## Getting Started

1. Install [Godot 4.6](https://godotengine.org/download) (Forward Plus renderer required).
2. Clone this repository:
   ```bash
   git clone https://github.com/huxiaoou/hus-rpg-beta.git
   ```
3. Open Godot and import the project by selecting the `project.godot` file.
4. Press **F5** (or click **Play**) to run the game.

## License

This project does not currently specify a license. All rights reserved by the author unless otherwise stated.
