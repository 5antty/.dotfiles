#!/bin/bash
set -e
#chmod +x install.sh

DOTFILES="$HOME/.dotfiles"

echo "→ Instalando dependencias..."
sudo pacman -S --needed stow curl hyprland hyprpaper hyprlauncher wl-clipboard waybar kitty zsh git fastfetch wlogout less zip unzip grim

# Instalar fuentes

# Llamar al script de la Nerd Font
echo "Instalando fuentes..."
if [ -f "$DOTFILES/install_font.sh" ]; then
    # Le damos permisos por si acaso y lo ejecutamos
    chmod +x "$DOTFILES/install_font.sh"
    "$DOTFILES/install_font.sh"
else
    echo "⚠️ No se encontró install_font.sh en $DOTFILES"
fi

# Llamar al script de la GRUB Theme
echo "Instalando tema para GRUB..."
if [ -f "$DOTFILES/install_grub_theme.sh" ]; then
    # Le damos permisos por si acaso y lo ejecutamos
    chmod +x "$DOTFILES/install_grub_theme.sh"
    "$DOTFILES/install_grub_theme.sh"
else
    echo "⚠️ No se encontró install_grub_theme.sh en $DOTFILES"
fi

# Instalar Starship
curl -sS https://starship.rs/install.sh | sh
touch "$HOME/.zshrc" # Para que se pueda agregar la configuración de los dotfiles
echo 'source "$HOME/.dotfiles/shell/.zshrc"' >> "$HOME/.zshrc"

# Instalar yay para paquetes AUR
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Dependencias principales de WAYBAR
sudo pacman -S otf-font-awesome ttf-fira-sans pavucontrol
# Nerd Fonts (íconos extra que usa el config)
sudo pacman -S ttf-nerd-fonts-symbols
# Para el módulo de notificaciones
sudo pacman -S swaync
# Para bluetooth
sudo pacman -S blueman
# Para Material Icons (íconos de notificaciones)
yay -S ttf-material-icons-git

git clone https://github.com/uiriansan/SilentSDDM.git
cd SilentSDDM

# Progromas para la terminal
sudo pacman -S glances exa lf

# Programas multimedia
sudo pacman -S vlc ffmpeg

# Preguntar por aplicaciones adicionales

echo "Quieres instalar Opera GX? (y/n)"
read -r response
if [ "$response" = "y" ]; then
    yay -S opera-gx
fi
echo "Quieres instalar Spotify? (y/n)"
read -r response
if [ "$response" = "y" ]; then
    yay -S spotify
fi 
echo "Quieres instalar Discord? (y/n)"
read -r response
if [ "$response" = "y" ]; then
    sudo pacman -S discord
fi
echo "Quieres instalar Visual Studio Code? (y/n)"
read -r response
if [ "$response" = "y" ]; then
    yay -S visual-studio-code-bin
fi
echo "Quieres instalar Heroic Games Launcher? (y/n)"
read -r response
if [ "$response" = "y" ]; then
    yay -S heroic-games-launcher-bin
fi

echo "→ Aplicando symlinks..."
cd "$DOTFILES"
stow . 

echo "✓ Listo!"