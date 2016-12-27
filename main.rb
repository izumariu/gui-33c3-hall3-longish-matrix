#!/usr/bin/ruby

begin
	require 'gtk3'
rescue LoadError => e
	puts "#{e.class}: #{e.message}"
end

require 'socket'

builder_f=File.expand_path(__FILE__);builder_f=builder_f.split("/");builder_f[-1]="";builder_f=builder_f.join("/")+"interface.ui"
builder = Gtk::Builder.new(:file=>builder_f)
mainwindow = builder.get_object("mainwindow")
mainwindow.signal_connect("destroy"){Gtk.main_quit}
mainwindow.title = "Long matrix control(33c3 Hall 3)"
msgentry = builder.get_object("msgentry")
sendbutton=builder.get_object("sendbutton")
msgentry.signal_connect("activate"){sendbutton.activate}
sendbutton.signal_connect("activate"){
	s=UDPSocket.new;s.connect("151.217.1.45",12345)
	s.puts msgentry.text
	s.close
	Thread.new{
		sendbutton.sensitive=false
		cooldown_arr = (1..10).to_a
		txt = sendbutton.label
		for i in cooldown_arr
			sendbutton.label = "COOLDOWN(#{1+cooldown_arr[-1]-i})"
			sleep 1
		end
		sendbutton.label = txt
		sendbutton.sensitive=true
	}
}
Gtk.main
