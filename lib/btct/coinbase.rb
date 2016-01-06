require 'open-uri'

require 'btct/quote'

module BTCT
  class CoinbaseAPI
    def name
      "Coinbase"
    end

    def top
      top = JSON.parse open("https://api.exchange.coinbase.com/products/BTC-USD/book").read
      bid = top["bids"][0]
      ask = top["asks"][0]
      return Quote.new(bid[0].to_f, bid[1].to_f, name), Quote.new(ask[0].to_f, ask[1].to_f, name)
    end

    def ticker
      ticker = JSON.parse open("https://api.exchange.coinbase.com/products/BTC-USD/ticker").read
      Ticker.new(
        :last     => ticker["price"].to_f,
        :volume   => ticker["volume"].to_f,
        :high     => 0.0,
        :low      => 0.0,
        :time     => DateTime.now.new_offset(0),
        :exchange => name
      )
    end
  end
end
