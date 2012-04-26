=begin

Email a photo (or any file) from a "queue" folder to a specified email address at regular intervals and move the sent item to the "Sent" folder. Great for publishging to tumblr or delivering regular doses of goodness to special people.

INSTALLATION:
  1. Put the files on your server somewhere (maybe via SCP)
    %> scp -r * remote_user@remote_box:/home/user_name/path/to/files
  2. Update variables: to_address & @from_address OPTIONAL: subject, glob (to send other types of files), sent & queue dirs (if you want to use other paths)
  3. Install Pony Gem 
    %> gem install pony
  4. Fill up the queue directory with goodies (maybe via SCP)
    %> scp queue/* remote_user@remote_box.com:/home/user_name/path/to/queue    
  5. Make sure both directories are writeable by the script (probably wont ahve to do this if cron runs as yourself)
  6. Setup your Cron Job to call this script whenever you wish
    %> crontab -e
  	
example cron:
	55 */3 * * * /usr/local/rvm/bin/ruby-1.9.2-p318 /home/your_username/subdirectory/go.rb
	#Run at 55 minutes past the hour every three hours using a custom RVM managed ruby version.
		
=end
require 'pony'

to_address = "somebody@example.com"
@from_address = "from@example.com"

subject = "Special Delivery: #{Time.now.strftime("%Y-%m-%d %H:%M")}"

glob = "*.jpg" #get all jpg images...
sent_dir = "sent" #move sent files here...
queue_dir = "queue"

############### Nothing else to mess with down here... ###################


def send_file(path,to,subject="Attachment: #{Time.now.strftime('%D %T')}",from=@from_address)  
  puts "Sending #{path} to #{@address}" if @debug
  #must pass "nil" argument for orion (OCS Solutions) to send properly
  Pony.mail(:to => to, :from=>from, :subject => subject, :body => '', :via=>:sendmail, :attachments => {"image.jpg" => File.read(path)}, :via_options => { :location  => '/usr/sbin/sendmail', :arguments => nil})
end

#append our local directory to our folders in case we're running this from a cron job at the root.
run_dir = File.dirname(__FILE__)
queue_dir = run_dir + "/" + queue_dir
sent_dir = run_dir + "/" + sent_dir

#make our sent directory if it doesn't already exist
Dir.mkdir(sent_dir,755) unless File.exists? sent_dir

#get all files
files = Dir.glob("#{queue_dir}/#{glob}")

#choose one at random
file = files[rand * files.length]

#send it
send_file file, to_address, subject

#move it to the "sent" folder
File.rename "#{file}", "#{sent_dir}/#{File.basename(file)}"

#finito!
