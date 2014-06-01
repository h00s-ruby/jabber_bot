require 'jabber_bot'

bot = JabberBot.new({'host' => 'talk.google.com', 'JID' => 'hear_bot@gmail.com', 'resource' => 'bot', 'password' => 'bot_password', 'operators' => ['your_id@gmail.com']})

bot.add_command('hey?', 'hey?', 'responds if bot hears you') do |params|
  params['jabber'].say(params['message'].from, 'hello there!')
end

bot.connect()
bot.listen()

while true
  sleep(120)
end

bot.disconnect()

