module BTCT
  class Quote
    attr_reader :price, :amount, :exchange

    def initialize(price, amount, exchange)
      @price, @amount, @exchange = price.to_f, amount.to_f, exchange
    end
  end
end