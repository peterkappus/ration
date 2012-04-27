Ration
======

Email a photo (or any file) from a &quot;queue&quot; folder to a specified email address and move the sent item to the &quot;sent&quot; folder. 
Great for publishing to tumblr/facebook via email or delivering regular doses of goodness to special people. 

##Usage & Installation
1. Put the files on your server somewhere (maybe via SCP)

    %> scp -r * remote_user@remote_box:/home/user_name/path/to/files
2. Copy config.sample.yaml to config.yaml and update your config variables as needed
3. Install Pony Gem 

    %> gem install pony
4. Fill up the queue directory with goodies (maybe via SCP)

    %> scp queue/* remote_user@remote_box.com:/home/user_name/path/to/queue    
5. Make sure both directories are writeable by the script (probably wont ahve to do this if cron runs as yourself)
6. Setup your Cron Job to call this script whenever you wish

    %> crontab -e

###example cron:
    55 */3 * * * /usr/local/rvm/bin/ruby-1.9.2-p318 /home/peterk/toys/pb0t.tumblr.com/gen.rb
    #Run at 55 minutes past the hour every three hours using a custom RVM managed ruby version.

##To Do
* Put options in a config.yaml file. 
* Write some tests?
* Include server name (FQDN) in notification email

##Credits
  Ration uses Pony to send mail
  The rest is hacked together by Peter Kappus