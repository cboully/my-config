#!/usr/bin/env python3
# installez le paquet "psutil" avec la commande "pip3 install psutil --user"
import psutil
print(psutil.cpu_percent(interval=1), end='')
