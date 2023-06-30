#!/usr/bin/bash

bg_bar_color="#282A36"

# Print a left caret separator
# @params {string} $1 text color, ex: "#FF0000"
# @params {string} $2 background color, ex: "#FF0000"
separator() {
  echo -n "{"
#  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"full_text\":\"\"," # CTRL+Ue0b2
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border\":\"$bg_bar_color\","
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"color\":\"$1\","
  echo -n "\"background\":\"$2\""
  echo -n "}"
}

common() {
  echo -n "\"border\": \"$bg_bar_color\","
  echo -n "\"separator\":false,"
  echo -n "\"separator_block_width\":0,"
  echo -n "\"border_top\":2,"
  echo -n "\"border_bottom\":2,"
  echo -n "\"border_left\":0,"
  echo -n "\"border_right\":0"
}

myspotify() {
  local bg="#FFD180"
  separator $bg $bg_bar_color
  echo -n ",{"
  echo -n "\"name\":\"id_spotify\","
  echo -n "\"full_text\":\" $($HOME/.config/statusbar/spotify.py | sed -e 's/\"/\\\"/g' ) \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

myip_public() {
  local bg="#1976D2"
  separator $bg "#FFD180"
  echo -n ",{"
  echo -n "\"name\":\"ip_public\","
  echo -n "\"full_text\":\" $(${HOME}/.config/statusbar/ip.py) \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

notification_on() {
  local bg="#92c25c"
  local icon=""
  if [[ $(dunstctl is-paused) == "true" ]];then
    bg="#E53935" # rouge
    icon=""
  fi
  separator $bg "#1976D2" # background left previous block
  bg_separator_previous=$bg
  echo -n ",{"
  echo -n "\"name\":\"id_notification\","
  echo -n "\"full_text\":\" ${icon} notification \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

myvpn_on() {
  if [ -e $HOME/.config/statusbar/status_vpn.sh ]
  then
    local bg="#424242" # grey darken-3
    local icon=""
    if [[ $($HOME/.config/statusbar/status_vpn.sh | grep "Disconnected") ]];then
      bg="#E53935" # rouge
      icon=""
    fi
    separator $bg "#1976D2" # background left previous block
    bg_separator_previous=$bg
    echo -n ",{"
    echo -n "\"name\":\"id_vpn\","
    echo -n "\"full_text\":\" ${icon} VPN \","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "},"
  fi
}

myip_local() {
  local bg="#2E7D32" # vert
  separator $bg $bg_bar_color
  bg_separator_previous=$bg
  echo -n ",{"
  echo -n "\"name\":\"ip_local\","
  echo -n "\"full_text\":\"  $(ip route get 1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

disk_usage() {
  local bg="#3949AB"
  separator $bg $bg_separator_previous
  echo -n ",{"
  echo -n "\"name\":\"id_disk_usage\","
  echo -n "\"full_text\":\" 💽 $($HOME/.config/statusbar/disk.py)%\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "}"
}

memory() {
  echo -n ",{"
  echo -n "\"name\":\"id_memory\","
  echo -n "\"full_text\":\" Mem:  $($HOME/.config/statusbar/memory.py)%\","
  echo -n "\"background\":\"#3949AB\","
  common
  echo -n "}"
}

cpu_usage() {
  bg_separator_previous=$bg
  echo -n ",{"
  echo -n "\"name\":\"id_cpu_usage\","
  echo -n "\"full_text\":\"  $($HOME/.config/statusbar/cpu.py)% \","
  echo -n "\"background\":\"#3949AB\","
  common
  echo -n "}"
}

meteo() {
  local bg="#546E7A"
  separator $bg "#3949AB"
  echo -n ",{"
  echo -n "\"name\":\"id_meteo\","
  echo -n "\"full_text\":\" $($HOME/.config/statusbar/meteo.py) \","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

mydate() {
  local bg="#E0E0E0"
  echo -n ","
  separator $bg "#3949AB"
  echo -n ",{"
  echo -n "\"name\":\"id_time\","
  echo -n "\"full_text\":\"  $(date "+%a %d/%m %H:%M") \","
  echo -n "\"color\":\"#000000\","
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
}

battery0() {
  if [ -f /sys/class/power_supply/BAT0/uevent ]; then
    local bg="#D69E2E"
    separator $bg "#E0E0E0"
    bg_separator_previous=$bg
    prct=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
    charging=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2) # POWER_SUPPLY_STATUS=Discharging|Charging
    icon=""
    if [ "$charging" == "Charging" ]; then
      icon=""
    fi
    echo -n ",{"
    echo -n "\"name\":\"battery0\","
    echo -n "\"full_text\":\" ${icon} ${prct}% \","
    echo -n "\"color\":\"#000000\","
    echo -n "\"background\":\"$bg\","
    common
    echo -n "}"
  else
    bg_separator_previous="#E0E0E0"
  fi
}

volume() {
  local bg="#673AB7"
  separator $bg $bg_separator_previous
  vol=$(pamixer --get-volume)
  echo -n ",{"
  echo -n "\"name\":\"id_volume\","
  if [ $vol -le 0 ]; then
    echo -n "\"full_text\":\"  ${vol}% \","
  else
    echo -n "\"full_text\":\"  ${vol}% \","
  fi
  echo -n "\"background\":\"$bg\","
  common
  echo -n "},"
  separator $bg_bar_color $bg
}

systemupdate() {
  local nb=$(checkupdates | wc -l)
  if (( $nb > 0)); then
    echo -n ",{"
    echo -n "\"name\":\"id_systemupdate\","
    echo -n "\"full_text\":\"  ${nb}\""
    echo -n "}"
  fi
}

logout() {
  echo -n ",{"
  echo -n "\"name\":\"id_logout\","
  echo -n "\"full_text\":\"  \""
  echo -n "}"
}

# https://github.com/i3/i3/blob/next/contrib/trivial-bar-script.sh
echo '{ "version": 1, "click_events":true }'     # Send the header so that i3bar knows we want to use JSON:
echo '['                    # Begin the endless array.
echo '[]'                   # We send an empty first array of blocks to make the loop simpler:

# Now send blocks with information forever:
(while :;
 do

	echo -n ",["
  #  myip_public
notification_on
myvpn_on
myspotify
myip_local
disk_usage
memory
cpu_usage
#  meteo
mydate
battery0
#  volume
#  systemupdate
logout
  echo "]"
	sleep 10
done)&

# click events
while read line;
do

  # VPN click
  if [[ $line == *"name"*"id_vpn"* ]]; then
    gnome-terminal -- $HOME/.config/statusbar/click_vpn.sh >/dev/null  2>&1 &

  # CHECK UPDATES
  elif [[ $line == *"name"*"id_systemupdate"* ]]; then
    gnome-terminal -- $HOME/.config/statusbar/click_checkupdates.sh &

  # CPU
  elif [[ $line == *"name"*"id_cpu_usage"* ]]; then
    gnome-terminal -- htop &

  # TIME
  elif [[ $line == *"name"*"id_time"* ]]; then
    gnome-terminal -- $HOME/.config/statusbar/click_time.sh >/dev/null 2>&1 &

  # METEO
  elif [[ $line == *"name"*"id_meteo"* ]]; then
    xdg-open https://openweathermap.org/city/2986140 > /dev/null &

  # VOLUME
  elif [[ $line == *"name"*"id_volume"* ]]; then
    gnome-terminal -- alsamixer &

  # LOGOUT
  elif [[ $line == *"name"*"id_logout"* ]]; then
    i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' >/dev/null 2>&1  &

  # SPOTIFY
  elif [[ $line == *"name"*"id_spotify"* ]]; then
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause >/dev/null 2>&1 &

  # NOTIFICATION
  elif [[ $line == *"name"*"id_notification"* ]]; then
    dunstctl set-paused toggle >/dev/null 2>&1  &

  fi
done
