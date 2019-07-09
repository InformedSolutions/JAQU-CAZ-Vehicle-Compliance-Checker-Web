run:
	gem install bundler --version=2.0.2
	mkdir -p ~/src
	rsync -av --progress /vagrant/. ~/src --exclude node_modules
	cd ~/src; bundle install; yarn install; rails server

unit-test:
	rspec -f d
	
scenario-test:
	cucumber
