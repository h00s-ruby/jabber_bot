require 'xmpp4r'
include Jabber

class JabberBot

  def initialize(config)
    @config = config
    @keep_alive_status = false
    @commands = {}
    @jabber = Client.new(JID::new(@config['JID'] + '/' + @config['resource']))
    #add_default_commands
    keep_alive
  end

  def connect
    begin
      if not @jabber.is_connected?
        @keep_alive_status = false
        @jabber.connect(@config['host'])
        @jabber.auth(@config['password'])
        @jabber.send(Presence.new.set_type(:available))
      end
    rescue Exception => e
      puts "Error connecting: #{e} (#{e.class})!"
    ensure
      @keep_alive_status = true
    end
  end

  def disconnect
    @keep_alive_status = false;
    @jabber.close
  end

  def listen
    @jabber.add_message_callback do |message|
      handle_message(message) unless message.body.to_s == ''
    end
  end

  def say(to, message)
    @jabber.send(Message.new(to, message).set_type(:chat))
  end

  def add_command(command, syntax, description, public = false, &callback)
    @commands[command.downcase] = {
        'syntax' => syntax,
        'description' => description,
        'callback' => callback,
        'public' => public
    }
  end

  def run_command(command, params)
    return @commands[command]['callback'].call(params)
  end

  private
  def handle_message(message)
    command = message.body.to_s.split(' ', 2)[0]
    command = command_available?(command)
    Thread.new do
      begin
        if @config['operators'].include?(message.from.to_s.sub(/\/.+$/, '')) or @commands[command]['public']
          params = {}
          params['parameters'] = message.body.to_s.split(' ', 2)[1]
          params['jabber'] = self
          params['message'] = message
          response = run_command(command, params)
        else
          response = 'Sorry, this command is not public or you\'re not an operator.'
        end
      rescue Exception => e
        response = "#{e} (#{e.class})!"
      ensure
        say(sender, response.to_s)
      end
    end unless command == nil
  end

  def command_available?(input)
    input = input.downcase.chomp(' ')
    if @commands.has_key?(input)
      return input
    else
      @commands.each_key do |command|
        if command.index(input, 0) == 0
          return command
        end
      end
      return nil
    end
  end

  def keep_alive
    Thread.new do
      while true
        if @keep_alive_status
          if @jabber.is_connected?
            begin
              @jabber.send(Presence.new.set_type(:available))
            rescue Exception => e
              puts "Error while keeping alive: #{e} (#{e.class})!"
            end
          else
            connect
          end
        end
        sleep(120)
      end
    end
  end
end