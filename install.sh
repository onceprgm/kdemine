#!/bin/bash

mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons/hicolor/256x256/apps

cp build/kdemine ~/.local/bin/kdemine
mkdir -p ~/.local/bin/qml/assets
cp -r build/qml/assets/* ~/.local/bin/qml/assets/

cp kdemine.desktop ~/.local/share/applications/kdemine.desktop
cp src/qml/assets/icon.png ~/.local/share/icons/hicolor/256x256/apps/kdemine.png

sed -i "s|Exec=kdemine|Exec=$HOME/.local/bin/kdemine|g" ~/.local/share/applications/kdemine.desktop

update-desktop-database ~/.local/share/applications

echo "Installation complete! Run 'KDE Mine' from your application menu."