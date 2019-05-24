GOP POLL BOT

Facilitates quick fill for form at https://whitehouse.typeform.com/to/Jti9QH, for your convenience.

NOTE

It is suggested you use a VPN or proxy.

FEATURES

Repeatedly fills in the poll without DOS'ing the site. Adds in commentary that is semi-randomly generated and can be
swapped out with whatever you want.

DEPENDENCIES

phantomjs

ruby

gems
	capybara
	poltergeist

QUICKSTART

./run.rb

LONGSTART

install phantomjs

	http://phantomjs.org/download.html

install ruby version manager
	https://rvm.io/rvm/install

		gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
		curl -sSL https://get.rvm.io | bash -s stable --ruby

install gems

		gem install capybara
		gem install poltergeist

run

	./run.rb
