#!/usr/bin/env python3
import dbus
import sys

import psutil

def checkIfProcessRunning(processName):
    '''
    Check if there is any running process that contains the given name processName.
    '''
    #Iterate over the all the running process
    for proc in psutil.process_iter():
        try:
            # Check if process name contains the given name string.
            if processName.lower() in proc.name().lower():
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    return False;


if checkIfProcessRunning("spotify"):
    session_bus = dbus.SessionBus()
    #print ("test1")

    spotify_bus = session_bus.get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
    #print ("test2")

    spotify_properties = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
    #print ("test4")

    metadata = spotify_properties.Get("org.mpris.MediaPlayer2.Player","Metadata")
    #print ("test5")

    print(str(metadata['xesam:artist'][0]), '~',  metadata['xesam:title'])
    #print ("test6")

else:
    print("[No play]")
