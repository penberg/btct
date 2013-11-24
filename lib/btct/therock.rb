require 'open-uri'

require 'btct/quote'

module BTCT
  class TheRockAPI
    def name
      "The Rock"
    end

    def top
      ob = JSON.parse open("https://www.therocktrading.com/api/orderbook/BTCUSD").read
      bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end

    def ticker
      ticker = JSON.parse open("https://www.therocktrading.com/api/ticker/BTCUSD").read
      ticker = ticker["result"][0]
      Ticker.new(
        :last     => ticker["last"].to_f,
        :volume   => 0.0,
        :high     => 0.0,
        :low      => 0.0,
        :time     => DateTime.now.new_offset(0),
        :exchange => name
      )
    end
  end
end
