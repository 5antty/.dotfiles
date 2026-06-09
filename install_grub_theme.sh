#!/bin/bash

# Salir inmediatamente si algún comando falla
set -e

# Definir variables
URL_TEMA="https://dl.opendesktop.org/api/files/download/id/1466632483/Shodan.zip"
RUTA_THEMES="/boot/grub/themes"
TEMP_DIR=$(mktemp -d)

echo "Iniciando la instalación automatizada del tema Shodan para GRUB..."

# 1. Comprobar dependencias básicas
for cmd in wget unzip; do
    if ! command -v $cmd &> /dev/null; then
        echo "Instalando dependencia faltante: $cmd..."
        sudo pacman -S --noconfirm $cmd
    fi
done

# 2. Descargar y descomprimir en un directorio temporal
echo "Descargando el tema desde Gnome-Look..."
wget -q --show-progress "$URL_TEMA" -O "$TEMP_DIR/Shodan.zip"

echo "Descomprimiendo archivos..."
unzip -q "$TEMP_DIR/Shodan.zip" -d "$TEMP_DIR/extracted"

# 3. Mover los archivos a la ruta del GRUB
echo "Configurando directorios de GRUB..."
sudo mkdir -p "$RUTA_THEMES"

# El zip contiene una carpeta interna llamada 'Shodan'
if [ -d "$TEMP_DIR/extracted/Shodan" ]; then
    sudo cp -r "$TEMP_DIR/extracted/Shodan" "$RUTA_THEMES/"
else
    # Por si acaso la estructura del zip cambia en un futuro
    sudo mkdir -p "$RUTA_THEMES/Shodan"
    sudo cp -r "$TEMP_DIR/extracted/"* "$RUTA_THEMES/Shodan/"
fi

# Limpiar directorio temporal
rm -rf "$TEMP_DIR"

# 4. Modificar /etc/default/grub de forma segura
echo "Configurando /etc/default/grub..."

# Habilitar o cambiar la línea del tema
if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/Shodan/theme.txt"|' /etc/default/grub
elif grep -q "^#GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^#GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/Shodan/theme.txt"|' /etc/default/grub
else
    echo 'GRUB_THEME="/boot/grub/themes/Shodan/theme.txt"' | sudo tee -a /etc/default/grub > /dev/null
fi

# Configurar resolución recomendada (1920x1080) para evitar distorsiones
if grep -q "^GRUB_GFXMODE=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_GFXMODE=.*|GRUB_GFXMODE="1920x1080"|' /etc/default/grub
fi

# 5. Actualizar el cargador de arranque
echo "Regenerando la configuración de GRUB..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "¡Instalación completada con éxito! El tema Shodan se mostrará en tu próximo inicio."