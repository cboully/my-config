#!/usr/bin/bash

GCAL="--iso-week-number=yes --with-week-number --starting-day=Monday" gcal $(date "+%Y") # affiche le calendrier de l'année
#cal -y            # affiche le calendrier de l'année
read -s            # attend une touche clavier pour quitter le terminal
