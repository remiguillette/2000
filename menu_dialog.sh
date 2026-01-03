#!/bin/bash

# Petite sécurité : si dialog n'est pas installé
command -v dialog >/dev/null 2>&1 || { echo "dialog n'est pas installé"; exit 1; }

while true; do
  # 1) On affiche un menu et on récupère le choix
  choix=$(dialog --clear \
    --backtitle "Mon programme" \
    --title "Please select" \
    --menu "Choisis une option :" 15 50 5 \
    1 "Lister les fichiers" \
    2 "Afficher la date" \
    3 "Quitter" \
    2>&1 >/dev/tty)

  # 2) Si l'utilisateur fait ESC ou Cancel, dialog renvoie un code ≠ 0
  retour=$?
  if [ $retour -ne 0 ]; then
    clear
    exit 0
  fi

  # 3) Actions selon le choix
  case "$choix" in
    1)
      # On affiche la sortie dans une "box" scrollable
      dialog --title "Liste des fichiers" --textbox <(ls -l) 20 70
      ;;
    2)
      dialog --title "Date et heure" --msgbox "$(date)" 8 40
      ;;
    3)
      clear
      exit 0
      ;;
  esac
done
