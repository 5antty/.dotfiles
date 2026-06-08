#!/bin/bash
#chmod +x install_font.sh
# Salir inmediatamente si un comando falla
set -e

FONT_NAME="DepartureMono"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
INSTALL_DIR="$HOME/.local/share/fonts"
TMP_DIR="/tmp/departure_mono_install"

echo "📦 Asegurando dependencias (curl, unzip, fontconfig)..."
if ! command -v curl &> /dev/null || ! command -v unzip &> /dev/null; then
    sudo pacman -S --needed --noconfirm curl unzip fontconfig
fi

echo "📁 Creando directorios..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$TMP_DIR"

echo "📥 Descargando ${FONT_NAME} Nerd Font desde GitHub..."
curl -L "$URL" -o "${TMP_DIR}/${FONT_NAME}.zip"

echo "🔓 Descomprimiendo archivos..."
unzip -o "${TMP_DIR}/${FONT_NAME}.zip" -d "$INSTALL_DIR"

echo "🧹 Limpiando archivos temporales..."
rm -rf "$TMP_DIR"

echo "🔄 Actualizando la caché de fuentes del sistema..."
fc-cache -fv