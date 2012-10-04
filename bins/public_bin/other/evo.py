#!/usr/bin/env python

import dbus
import dbus.glib
import gobject

bus = dbus.SessionBus()
bus.get_object("org.freedesktop.DBus","/org/freedesktop/DBus")
notify_service = bus.get_object('org.freedesktop.Notifications', '/org/freedesktop/Notifications')
notify_interface = dbus.Interface(notify_service, 'org.freedesktop.Notifications')

def newmail_handler(msg, msg2):
    notify_interface.Notify("evo-notify", 0, '', "New Email", msg, [], {}, -1)

bus.add_signal_receiver(newmail_handler, dbus_interface = "org.gnome.evolution.mail.dbus.Signal", signal_name = "Newmail")

loop = gobject.MainLoop()
loop.run()
