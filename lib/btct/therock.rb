require 'open-uri'

require 'btct/quote'

module BTCT
  class TheRockAPI
    def name
      "The Rock"
    end

    def top
      begin
        ob = JSON.parse open("https://www.therocktrading.com/api/orderbook/BTCUSD").read
        bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
        ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
        return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
      rescue
        return Quote.new(0.0, 0.0, name), Quote.new(0.0, 0.0, name)
      end
    end
  end
end