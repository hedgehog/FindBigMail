Install the 1.9.2-p29 ruby from http://rubyinstaller.org/downloads/ (windows)
	Install it somewhere like c:\ruby
	During install check "Add Ruby executables to your path"
	During install check "Associate .rb and .rbw files with this..."

Get a new command prompt
Run:
	gem install bundler
Run:
	gem install middleman
Get a new command prompt
Go to the FindBigMail dir
Run:
	middleman server -p 4567 -e development
	If windows firewall asks what you want to do about it, unblock it.
	It takes a few seconds to show up after starting

To view the content, point a browser at: http://localhost:4567/en/index.html

To see content changes minus en.yml, refresh the browser after saving

To see en.yml changes, rerun middleman
