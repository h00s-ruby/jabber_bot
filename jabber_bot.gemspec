# encoding: utf-8

require File.expand_path('../lib/jabber_bot', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'jabber_bot'
  gem.version       = '0.0.1'
  gem.date          = '2014-06-02'

  gem.summary       = 'Simple Jabber bot'
  gem.description   = 'Simple Jabber bot with the use of xmpp4r'
  gem.license       = 'MIT'
  gem.authors       = ['Krunoslav Husak']
  gem.email         = 'kruno@binel.hr'
  gem.homepage      = 'https://github.com/h00s/jabber_bot'

  gem.files         = ['lib/jabber_bot.rb']
  gem.require_paths = ['lib']

  gem.add_development_dependency 'xmpp4r', '~> 0'
end