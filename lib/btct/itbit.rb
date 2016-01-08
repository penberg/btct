require 'open-uri'

require 'btct/quote'

module BTCT
  class ItBitAPI
    def name
      "itBit"
    end

    def top
      top = JSON.parse open("https://api.itbit.com/v1/markets/XBTUSD/order_book").read
      bid = top["bids"][0]
      ask = top["asks"][0]
      return Quote.new(bid[0].to_f, bid[1].to_f, name), Quote.new(ask[0].to_f, ask[1].to_f, name)
    end

    def ticker
      ticker = JSON.parse open("https://api.itbit.com/v1/markets/XBTUSD/ticker").read
      Ticker.new(
        :last     => ticker["lastPrice"].to_f,
        :volume   => ticker["volume24h"].to_f,
        :high     => ticker["high24h"].to_f,
        :low      => ticker["low24h"].to_f,
        :time     => DateTime.now.new_offset(0),
        :exchange => name
      )
    end
  end
end
