# KDE Mine

A native, guess-free Minesweeper clone built with Qt 6 (QML) and C++20, optimized specifically for Linux/KDE Plasma desktops.

## Features
*   **Guess-Free Board Generation:** Mathematical solver verification on first click.
*   **Auto-Scaling Grid:** Grid cells automatically scale down to fit any window size.
*   **Two UI Themes:** Choose between modern Breeze Dark and Classic Retro (Windows 95 style).
*   **Low-Latency Audio:** Audio cues played natively via PulseAudio/PipeWire.
*   **XDG Configuration:** Settings are stored in accordance with system standards.

## How to Build

### 1. Install Dependencies

#### Debian / Ubuntu
```bash
sudo apt install build-essential cmake ninja-build clang qt6-base-dev qt6-declarative-dev extra-cmake-modules
```

#### Fedora
```bash
sudo dnf install gcc-c++ cmake ninja-build clang qt6-qtbase-devel qt6-qtdeclarative-devel extra-cmake-modules
```

#### Arch Linux
```bash
sudo pacman -S --needed base-devel cmake ninja clang qt6-base qt6-declarative extra-cmake-modules
```

### 2. Compilation
```bash
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

## Installation
Run the local installer script (this copies the binary, copies the custom landmine icon, and registers the desktop application menu shortcut):
```bash
./install.sh
```

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.