# KDE Mine

A native, guess-free Minesweeper clone built with Qt 6 (QML) and C++20, designed for Linux/KDE Plasma desktops.

## Features

- **Guess-Free Board Generation:** On first click, a constraint-based solver verifies the board is logically solvable without guessing. If a solvable layout cannot be found within 1000 attempts, the game continues with a standard random board and displays a warning.
- **Auto-Scaling Grid:** Grid cells automatically scale to fit any window size.
- **Two UI Themes:** Modern Breeze Dark and Classic Retro (Windows 95 style).
- **Three Languages:** English, Russian, Chinese.
- **Low-Latency Audio:** Sound cues played natively via PulseAudio/PipeWire (`paplay`).
- **XDG Configuration:** Settings stored in `~/.config/KDEMineProject/kdemine.ini`.

## How to Build

### 1. Install Dependencies

#### Arch Linux
```bash
sudo pacman -S --needed base-devel cmake ninja clang qt6-base qt6-declarative extra-cmake-modules
```

#### Debian / Ubuntu
```bash
sudo apt install build-essential cmake ninja-build clang qt6-base-dev qt6-declarative-dev extra-cmake-modules
```

#### Fedora
```bash
sudo dnf install gcc-c++ cmake ninja-build clang qt6-qtbase-devel qt6-qtdeclarative-devel extra-cmake-modules
```

### 2. Build

```bash
./build.sh
```

Builds in Release mode by default. Pass `Debug` for a debug build:

```bash
./build.sh Debug
```

Or manually:

```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

### 3. Run

```bash
./build/kdemine
```

## Installation

Installs the binary, assets, icon, and `.desktop` entry to `~/.local/`:

```bash
./install.sh
```

After installation, launch via `kdemine` in the terminal or from the application menu as **KDE Mine**.

## License

MIT — see [LICENSE](LICENSE).
