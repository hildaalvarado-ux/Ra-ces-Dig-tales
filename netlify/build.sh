#!/usr/bin/env bash
set -e

echo "Installing Flutter..."

git clone https://github.com/flutter/flutter.git -b stable --depth 1 $HOME/flutter

export PATH="$HOME/flutter/bin:$PATH"

flutter --version

flutter config --enable-web

flutter pub get

flutter build web --release