require 'redis'
require 'redis/script/version'

module Redis::Script

  module InstanceMethods
    def script_sha_from_command(command)
      @script_shas ||= {}
      @script_shas[command] ||= self.script(:load,command.lua)
    end

    def add_command(command)
      self.class.module_eval do
        define_method(command.name) do |*args|
          command.call(self,*args)
        end
      end
    end

    def add_commands(commands=nil,&blk)
      if blk
        commands = CommandBuilder.new(self).run(&blk)
      end

      commands.each {|c| add_command(c)}
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end

Redis.send(:include, Redis::Script)

require 'redis/script/command'
require 'redis/script/command_builder'