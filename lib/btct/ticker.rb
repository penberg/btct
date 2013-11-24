module BTCT
  class Ticker
    attr_reader :last, :volume, :high, :low, :time, :exchange

    def initialize(args)
      args.each { |k, v| instance_variable_set("@#{k}", v) unless v.nil? }
    end
  end
end
