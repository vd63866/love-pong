# Lua Pong

A simple arcade-style **Pong game built with Lua and LÖVE2D**.

This project started as a small learning project to understand the fundamentals of game development with Lua and LÖVE2D, including the game loop, movement, collision detection, AI, game states, and scoring.

## Features

* Player-controlled paddle
* Computer-controlled opponent
* Ball and paddle collision
* Angle-based ball bouncing
* Increasing ball speed during rallies
* First-to-5 scoring system
* Start countdown
* Pause and resume
* Game-over screen
* Restart functionality
* Simple arcade-style visuals

## Controls

| Key     | Action                  |
| ------- | ----------------------- |
| `W`     | Move paddle up          |
| `S`     | Move paddle down        |
| `P`     | Pause / resume          |
| `ESC`   | Pause / resume          |
| `SPACE` | Start game from menu    |
| `ENTER` | Start / restart         |
| `R`     | Restart after game over |

## Requirements

You need:

* [Lua](https://www.lua.org/)
* [LÖVE2D](https://love2d.org/)
* Git (optional, for development)

## Installation

### Arch Linux / Manjaro

Install Lua and LÖVE2D with:

```bash
sudo pacman -S lua love
```

Check the installations:

```bash
lua -v
love --version
```

### Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/love-pong.git
cd love-pong
```

Replace `YOUR-USERNAME` with the GitHub username that owns the repository.

## Run the Game

From the project directory:

```bash
love .
```

LÖVE2D will look for `main.lua` at the top level of the project.

## How to Play

The left paddle is controlled by the player.

Move it with:

```text
W - Up
S - Down
```

The right paddle is controlled by the computer.

The ball changes its angle depending on where it hits the paddle. Successful returns also increase the ball speed, making longer rallies more challenging.

The first player to reach **5 points** wins.

## Project Structure

```text
love-pong/
├── main.lua
├── .gitignore
└── README.md
```

## What I Learned

This project was built as a learning exercise and introduced several core game-development concepts:

* `love.load()` for game initialization
* `love.update(dt)` for game logic
* `love.draw()` for rendering
* Keyboard input with LÖVE2D
* Delta time (`dt`)
* Axis-aligned collision detection
* Simple enemy AI
* Game states
* Score tracking
* Ball physics
* Restarting and resetting game state

## Future Improvements

Possible future improvements include:

* Better visual effects
* Ball trails
* Particle effects
* Improved AI difficulty
* Better menus
* Sprites and animations
* Sound effects
* Background music

## Status

**Completed learning project**

The current version is intentionally simple and focuses on understanding the fundamentals of Lua and LÖVE2D.

## Author

Built as a beginner game-development project while learning Lua and LÖVE2D.
