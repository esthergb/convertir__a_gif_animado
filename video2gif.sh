#!/usr/bin/env sh

function crear_paleta()
{
    ffmpeg -y $posicion_inicial $posicion_final -i "$fichero" -vf fps=10,scale=$ancho:-1:flags=lanczos,palettegen palette.png
}

function convertir()
{
    ffmpeg $posicion_inicial $posicion_final -i "$fichero" -i palette.png -filter_complex "fps=10,scale=$ancho:-1:flags=lanczos[x];[x][1:v]paletteuse" "${fichero%\.*}.gif"
    rm palette.png
}

fichero=$1
if [[ ! -f "$fichero" ]]; then
    echo "¡Error! No encuentro \'$fichero\'"
    exit 1
fi 

echo -e "\n¿Quieres definir un tiempo de inicio? (S/N)"
read confirm
if [[ "${confirm,,}" == "s" ]]; then
    echo -e "\nFormatos posibles:\nHH:MM:SS.xxx\nHH:MM:SS\nSS"
    echo "¿Posición?:"
    read inicio
    echo -e "\n¿Quieres definir una duración? (S/N)"
    read confirm_1
    if [[ "${confirm_1,,}" == "s" ]]; then 
        echo -e "\nFormatos posibles:\nHH:MM:SS.xxx\nHH:MM:SS\nSS"
        echo "¿Duración?"
        read duracion
    fi 
fi 
echo -e "\nAncho en pixels (320,640,720,etc):"
read ancho

[[ -z $inicio ]] || posicion_inicial="-ss $inicio"
[[ -z $duracion ]] || posicion_final="-t $duracion"

crear_paleta
convertir
