#!/usr/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import os
import tempfile

class TextViewExample:

    def close_application(self, widget):
        gtk.main_quit()

    def add_bannedsites(self, widget):
        print "Adding sites..."
        model = self.combobox.get_model()
        index = self.combobox.get_active()
        if index>-1:
	    script_name=model[index][0]
	else:
	    return

	start=self.textbuffer.get_start_iter()
	end=self.textbuffer.get_end_iter()
	string = self.textbuffer.get_text(start,end)

	filename = tempfile.mktemp()
	outfile = open(filename, "w")
        if outfile:
	    print "name="+outfile.name
            outfile.write(string)
            outfile.close()
	    self.textbuffer.delete(start,end)
	    terminal="xterm -hold -e "
	    script_dir='/usr/share/webcontentcontrol/scripts/'
	    script="sudo "+script_dir+script_name+" "
	    #script="cat "
	    command=terminal+script+outfile.name
	    print "=========================="
	    print "===RUNNING COMMAND========"
	    print "command:"
	    print command
	    print "=========================="
	    os.system(command)
	    print "=========================="
	    print "===RUNNING COMMAND DONE==="
	    print "=========================="

    def __init__(self):
        window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window.set_resizable(True)
	window.set_default_size(500, 500)

        window.connect("destroy", self.close_application)
        window.set_title("Add banned sites on the fly :)")
        window.set_border_width(0)

        box1 = gtk.VBox(False, 0)
        window.add(box1)
        box1.show()

	self.combobox = gtk.combo_box_new_text()
        box1.pack_start(self.combobox, False, True, 0)
	self.combobox.show()

	script_list=['add_bannedextension_fromfile.sh', 'add_bannedip_fromfile.sh', 'add_bannedmimetype_fromfile.sh', 'add_bannedphrase_fromfile.sh', 'add_bannedregexpheader_fromfile.sh', 'add_bannedregexpurl_fromfile.sh', 'add_bannedsite_fromfile.sh', 'add_bannedurl_fromfile.sh']

	liststore = gtk.ListStore(str)
        for n in range(len(script_list)):
            liststore.append([ script_list[n] ])

        self.combobox.set_model(liststore)
        self.combobox.set_active(6)

        sw = gtk.ScrolledWindow()
        sw.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        textview = gtk.TextView()
        self.textbuffer = textview.get_buffer()
        sw.add(textview)
        sw.show()
        textview.show()

        box1.pack_start(sw)

        separator = gtk.HSeparator()
        box1.pack_start(separator, False, True, 0)
        separator.show()

        button = gtk.Button("Add")
	button.set_size_request(-1,50)
        button.connect("clicked", self.add_bannedsites)
        box1.pack_start(button, False, True, 0)
        button.set_flags(gtk.CAN_DEFAULT)
        button.grab_default()
        button.show()
        window.show()

def main():
    gtk.main()
    return 0

if __name__ == "__main__":
    TextViewExample()
    main()
