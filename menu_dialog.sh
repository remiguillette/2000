#!/bin/bash

# Petite sécurité : si dialog n'est pas installé
command -v dialog >/dev/null 2>&1 || { echo "dialog n'est pas installé"; exit 1; }

retro_dialogrc=$(mktemp)
trap 'rm -f "$retro_dialogrc"' EXIT

cat > "$retro_dialogrc" <<'RC'
use_colors = ON
screen_color = (BLACK,BLACK,ON)
title_color = (YELLOW,BLACK,ON)
border_color = (YELLOW,BLACK,ON)
button_active_color = (BLACK,YELLOW,ON)
button_inactive_color = (YELLOW,BLACK,OFF)
button_label_active_color = (BLACK,YELLOW,ON)
button_label_inactive_color = (YELLOW,BLACK,OFF)
item_color = (YELLOW,BLACK,OFF)
item_selected_color = (BLACK,YELLOW,ON)
tag_color = (YELLOW,BLACK,ON)
tag_selected_color = (BLACK,YELLOW,ON)
inputbox_color = (YELLOW,BLACK,ON)
menubox_color = (YELLOW,BLACK,OFF)
menubox_border_color = (YELLOW,BLACK,ON)
RC
export DIALOGRC="$retro_dialogrc"

while true; do
  # 1) On affiche un menu et on récupère le choix
  choix=$(dialog --clear \
    --backtitle "BeaverTUI" \
    --title "BeaverTUI" \
    --menu "Choisis une option dans le menu rétro :" 15 50 5 \
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
