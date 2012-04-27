#!/usr/bin/ruby
require 'pony'
require 'yaml'

@config = YAML::load_file 'config.yaml'

to_address = @config['to']
@from_address = @config['from']
@notify_address = @config['notify']# "somebody@whomever.com" #send mail when queue gets low

subject = "Special Delivery: #{Time.now.strftime("%Y-%m-%d %H:%M")}"

glob = "*.jpg" #get all jpg images...
sent_dir = @config['sent_dir'] || "sent" #move sent files here...
queue_dir = @config['queue_dir'] || "queue"

############### These are not the droids you're looking for... ###################


def send_file(path,to,subject="Attachment: #{Time.now.strftime('%D %T')}",from=@from_address)  
  puts "Sending #{path} to #{@address}" if @debug
  #must pass "nil" argument for orion (OCS Solutions) to send properly
  Pony.mail(:to => to, :from=>from, :subject => subject, :body => '', :via=>:sendmail, :attachments => {"image.jpg" => File.read(path)}, :via_options => { :location  => '/usr/sbin/sendmail', :arguments => nil})
end

#append our local directory to our folders in case we're running this from a cron job at the root.
run_dir = File.dirname(__FILE__)
queue_dir = run_dir + "/" + queue_dir
sent_dir = run_dir + "/" + sent_dir


#alert the admin if our queue is running low... need to DRY this up.
if(Dir.glob("#{queue_dir}/#{glob}").count < 10)
  #TODO: include the machine name or IP in the body...
  #try this: 
  hostname = Socket.gethostbyname(Socket.gethostname).first
  Pony.mail(:to => @notify_address, :from=>@from_address, :subject => "Your Ration queue is running low!", :body => 'Go fill \'er up...', :via=>:sendmail, :via_options => { :location  => '/usr/sbin/sendmail', :arguments => nil})
end


#make our sent directory if it doesn't already exist
Dir.mkdir(sent_dir,755) unless File.exists? sent_dir

#get all files
files = Dir.glob("#{queue_dir}/#{glob}")

#choose one at random
file = files[rand * files.length]

#send it
send_file file, to_address, subject

#move it to the "sent" folder
File.rename "#{file}", "#{sent_dir}/#{File.basename(file)}" if file

#finito!
