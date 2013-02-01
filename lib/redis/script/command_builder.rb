module Redis::Script
  class CommandBuilder
    attr_reader :redis
    def initialize(redis)
      @redis = redis
    end

    def run &blk
      @commands = []
      instance_eval(&blk)
      @commands
    end

    def after_run name, &blk
      command = @commands.find {|c| c.name == name}
      if command
        command.after_run(&blk)
      end
    end

    def method_missing name, *args
      lua = args.pop if args.last.is_a?(String)
      if args.first.is_a?(Integer)
        keys = args.first
      else
        keys = args.length
      end
      @commands << Command.new(name,keys: keys, lua: lua)
    end
  end
end