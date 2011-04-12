#!/usr/bin/env ruby

require "net/http"
require "rexml/document"

require "gtk2"
require "gtkmozembed"

$feed_url = "http://feeds.feedburner.com/ICanHasCheezburger"

class DeskCat < Gtk::Window
  def initialize
    super Gtk::Window::TOPLEVEL
    # Make the program end when the window is closed
    signal_connect("destroy") {Gtk.main_quit}
    # Set the window title and default size
    self.title = "You Has LOLCAT"
    set_default_size(300,500)
    # Add a toolbar, Gecko rendeirng widget, and statusbar to the window
    self << vbox = Gtk::VBox.new
    vbox.pack_start @toolBar = Gtk::Toolbar.new, false, false
    vbox.pack_start @webBrowse = Gtk::MozEmbed.new
    vbox.pack_start @statusBar = Gtk::Statusbar.new, false, false
    # Populate the toolbar
    @toolBar.append(Gtk::ToolButton.new(Gtk::Stock::REFRESH)).signal_connect("clicked") {update}
    @toolBar.append(Gtk::ToolButton.new(Gtk::Stock::QUIT)).signal_connect("clicked") {Gtk.main_quit}
    @toolBar.append(Gtk::ToolButton.new(Gtk::Stock::HOME)).signal_connect("clicked") {fork {`firefox 'http://icanhascheezburger.com'`}}
    @toolBar.append Gtk::SeparatorToolItem.new
    @toolBar.append Gtk::ToolItem.new.add(Gtk::Label.new("Update interval: "))
    @toolBar.append Gtk::ToolItem.new.add(@updateInterval = Gtk::SpinButton.new(1,100,1))
    # Adjust the timer when the update interval value is changed
    @updateInterval.signal_connect("value-changed") {|w| setup_timer}
    # Set the default update interval value to 30
    @updateInterval.value = 30
  end

  def setup_timer
    # If a timer is already set up, remove it
    Gtk.timeout_remove(@timeOut) if @timeOut
    # Create a timer that causes update every x number of minutes
    @timeOut = Gtk.timeout_add(
      60000 * @updateInterval.value) {self.update; true}
  end

  def update
    # Load and parse the RSS content
    doc = REXML::Document.new(Net::HTTP.get_response(URI.parse($feed_url)).body)
    # Set the time of the last update in the toolbar
    @statusBar.push(0, Time.now.strftime("Last update: %I:%M:%S %p"))
    # Prepare to push html data into the Gecko widget
    @webBrowse.open_stream "file:///", "text/html"
    # Put the pictures in the Gecko widget...
    @webBrowse.append_data %(<body style="background-color: #F7F7F7">)
    # Iterate through all of the media:content elements in the feed
    doc.elements.each("//media:content") do |x|
      # Extract the URL of the image
      img = x.attributes["url"]
      # Generate the html for an image and add it to the Gecko widget
      @webBrowse.append_data %(<div style="border: 3px outset grey"><img width="100%" src="#{img}" /></div><br />)
    end
    @webBrowse.close_stream
  end
end

# Create the window, set the timer, and perform an update
w = DeskCat.new.show_all; w.setup_timer; w.update
Gtk.main
