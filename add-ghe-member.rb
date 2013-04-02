#!/usr/bin/env ruby

require 'mechanize'
require 'pit'

file = ARGV[0]

if ! file
  puts "Usage #{$0} file"
  exit
end

users = []
lines = File.read(file).split(/\n/)
lines.each do |line|
  ( login, email ) = line.split(/\s+/)
  users << { login: login, email: email }
end

config = Pit.get('ghe', :require => {
  'username' => 'Your user name of GitHub Enterprise',
  'password' => 'Your password of GitHub Enterprise',
})

agent = Mechanize.new

page = agent.get('http://ghe.tokyo.pb/')

login_form = page.form
login_form.field_with(name: 'login').value    = config['username']
login_form.field_with(name: 'password').value = config['password']

agent.submit(login_form)

page = agent.get('http://ghe.tokyo.pb/stafftools/invite')

invite_form = nil
page.forms.each do |f|
  invite_form = f if f.action == '/stafftools/invite'
end

users.each do |user|
  puts "Adding #{user[:login]} (#{user[:email]}) ..."
  invite_form.field_with(name: 'user[login]').value = user[:login]
  invite_form.field_with(name: 'user[email]').value = user[:email]
  #agent.submit(invite_form)
end


