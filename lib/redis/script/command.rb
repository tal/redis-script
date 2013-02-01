module Redis::Script
  class Command
    attr_reader :name, :keys

    def initialize name, opts
      @name = name
      @keys = opts[:keys]||0
      @lua  = opts[:lua]

      @processors = []

      if opts[:after_run]
        @processors << opts[:after_run]
      end
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

      val = redis.evalsha(sha(redis),keys,args)
      process_return(val)
    end

    def after_run &blk
      @processors << blk
    end

    private

    def process_return(val)
      @processors.each do |proc|
        val = proc.call(val) if proc
      end
      val
    end

  end
end