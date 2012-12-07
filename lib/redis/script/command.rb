module Redis::Script
  class Command
    attr_reader :name, :keys

    def initialize name, opts
      @name = name
      @keys = opts[:keys]||0
      @lua  = opts[:lua]
    end

    def lua *args
      if args.empty?
        @lua
      else
        @lua = args.first
        self
      end
    end

    def sha(redis)
      redis.script_sha_from_command(self)
    end

    def call(redis,*args)
      keys = []
      @keys.times {keys << args.shift}

      redis.evalsha(sha(redis),keys,args)
    end

  end
end