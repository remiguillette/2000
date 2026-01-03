#!/bin/bash

# Petite sécurité : si dialog n'est pas installé
command -v dialog >/dev/null 2>&1 || { echo "dialog n'est pas installé"; exit 1; }

retro_dialogrc=$(mktemp)
trap 'rm -f "$retro_dialogrc"' EXIT

# Icône de castor (désactivable via BEAVER_ICON="" si besoin)
BEAVER_ICON=${BEAVER_ICON:-🦫}
TUI_TITLE="$BEAVER_ICON BeaverTUI"

cat > "$retro_dialogrc" <<'RC'
use_colors = ON
screen_color = (BLACK,BLACK,OFF)
border_color = (YELLOW,BLACK,OFF)
title_color = (YELLOW,BLACK,OFF)
menubox_color = (YELLOW,BLACK,OFF)
menubox_border_color = (YELLOW,BLACK,OFF)
item_color = (YELLOW,BLACK,OFF)
item_selected_color = (BLACK,YELLOW,OFF)
tag_color = (YELLOW,BLACK,OFF)
tag_selected_color = (BLACK,YELLOW,OFF)
button_inactive_color = (YELLOW,BLACK,OFF)
button_active_color = (BLACK,YELLOW,OFF)
button_label_inactive_color = (YELLOW,BLACK,OFF)
button_label_active_color = (BLACK,YELLOW,OFF)
inputbox_color = (YELLOW,BLACK,OFF)
RC
export DIALOGRC="$retro_dialogrc"

while true; do
  # Ajuste la taille en fonction du terminal (60 % de la hauteur/largeur)
  read -r ROWS COLS < <(stty size)
  H=$(( ROWS * 60 / 100 ))
  W=$(( COLS * 60 / 100 ))
  M=$(( H - 8 ))
  [ $H -lt 15 ] && H=15
  [ $W -lt 50 ] && W=50
  [ $M -lt 5 ] && M=5

  # 1) On affiche un menu et on récupère le choix
  choix=$(dialog --stdout --clear \
    --backtitle "$TUI_TITLE" \
    --title "$TUI_TITLE" \
    --menu "Choisis une option dans le menu rétro :" "$H" "$W" "$M" \
    1 "Lister les fichiers" \
    2 "Afficher la date" \
    3 "Quitter")

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
      dialog --stdout --title "$TUI_TITLE - Liste des fichiers" --textbox <(ls -l) "$H" "$W"
      ;;
    2)
      dialog --stdout --title "$TUI_TITLE - Date et heure" --msgbox "$(date)" 8 "$W"
      ;;
    3)
      clear
      exit 0
      ;;
  esac
done
