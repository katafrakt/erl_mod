module Noaidi
  ReturnContractViolation = Class.new(StandardError)

  class Fun
    attr_reader :name, :block, :module, :visibility

    def initialize(noaidi, name, args, block)
      @module = noaidi
      @name = name.to_sym
      @args = args.map{|a| Matcher.new(a)}
      @block = block
    end

    def call(*args)
      freeze unless frozen?
      instance_exec(*args, &@block)
    end

    def matches?(args)
      return false unless arity == args.length
      args.each_with_index do |arg, i|
        return false unless @args[i].match?(arg)
      end
      true
    end

    def method_missing(name, *args)
      @module.public_send(name, *args)
    end

    def set_visibility!(visibility)
      @visibility = visibility
    end

    private
    def arity
      @args.length
    end

    def arguments
      @args
    end
  end
end
