#!/usr/bin/zsh

# Carpetas de recursos
CARPETA_LOGOS="$HOME/.config/fastfetch/logos"
CARPETA_CONFIGS="$HOME/.config/fastfetch/configs"

# Configuración de tamaño para las imágenes PNG
ANCHO_PNG=36
ALTO_PNG=24

# 1. SELECCIÓN DE CONFIGURACIÓN ALEATORIA
# Si la carpeta de configs existe y tiene archivos .jsonc, elige uno. Si no, usa el defecto.
if [ -d "$CARPETA_CONFIGS" ] && [ "$(ls -A "$CARPETA_CONFIGS"/*.jsonc 2>/dev/null)" ]; then
    CONFIG_ALAZAR=$(find "$CARPETA_CONFIGS" -type f -name "*.jsonc" | shuf -n 1)
    ARGS_CONFIG=("-c" "$CONFIG_ALAZAR")
else
    ARGS_CONFIG=()
fi

# CORRECCIÓN: Usamos [[ ... ]] y evaluamos si la ruta termina con el nombre del archivo
if [[ "$CONFIG_ALAZAR" == *"config15.jsonc" ]]; then
    # CORRECCIÓN: Quitamos la tilde de las comillas y usamos $HOME para asegurar la ruta absoluta exacta
    fastfetch "${ARGS_CONFIG[@]}" --logo-type file --logo "$HOME/.config/fastfetch/logos/2b.txt"
else
    # 2. SELECCIÓN DE LOGO ALEATORIO Y EJECUCIÓN
    # Comprobar si la carpeta de logos existe y tiene archivos
    if [ -d "$CARPETA_LOGOS" ] && [ "$(ls -A "$CARPETA_LOGOS")" ]; then
        LOGO_ALAZAR=$(find "$CARPETA_LOGOS" -type f \( -name "*.png" -o -name "*.txt" \) | shuf -n 1)
        EXTENSION="${LOGO_ALAZAR##*.}"
        
        if [ "$EXTENSION" = "png" ]; then
            # Ejecuta con la config aleatoria + logo PNG
            fastfetch "${ARGS_CONFIG[@]}" --logo-type kitty-direct --logo "$LOGO_ALAZAR" --logo-width $ANCHO_PNG --logo-height $ALTO_PNG
        else
            # Ejecuta con la config aleatoria + logo TXT
            fastfetch "${ARGS_CONFIG[@]}" --logo-type file --logo "$LOGO_ALAZAR"
        fi
    else
        # Si no hay logos, ejecuta solo con la configuración aleatoria
        fastfetch "${ARGS_CONFIG[@]}"
    fi
fi