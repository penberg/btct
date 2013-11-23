require 'mtgox'

require 'btct/quote'

module BTCT
  class MtGoxAPI
    def name
      "Mt.Gox"
    end

    def top
      bid = MtGox.bids.sort { |x, y| x.price <=> y.price }.last
      ask = MtGox.asks.sort { |x, y| x.price <=> y.price }.first
      return Quote.new(bid.price, bid.amount, name), Quote.new(ask.price, ask.amount, name)
    end
  end
end