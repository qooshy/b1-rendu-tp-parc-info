#!/bin/bash

URL_FILE="/opt/yt/urls.txt"
LOG_FILE="/opt/yt/yt.log"

# Vérifier si le fichier d'URLs existe
if [[ ! -f "$URL_FILE" ]]; then
  echo "Fichier des URLs introuvable!" >> "$LOG_FILE"
  exit 1
fi

# Lire le fichier ligne par ligne
while IFS= read -r URL
do
  if [[ "$URL" =~ ^https://www.youtube.com/watch\?v= ]]; then
    # Téléchargement de la vidéo
    youtube-dl "$URL" >> "$LOG_FILE" 2>&1
    if [ $? -ne 0 ]; then
      echo "Erreur lors du téléchargement de $URL" >> "$LOG_FILE"
    else
      echo "Téléchargement de $URL terminé." >> "$LOG_FILE"
    fi
    # Supprimer l'URL après téléchargement
    sed -i '/^'"$URL"'/d' "$URL_FILE"
  else
    echo "URL invalide : $URL" >> "$LOG_FILE"
    # Supprimer l'URL invalide
    sed -i '/^'"$URL"'/d' "$URL_FILE"
  fi
done < "$URL_FILE"

echo "Fin du traitement des vidéos." >> "$LOG_FILE"