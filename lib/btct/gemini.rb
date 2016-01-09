require 'open-uri'

require 'btct/quote'

module BTCT
  class GeminiAPI
    def name
      "Gemini"
    end

    def top
      book = JSON.parse open("https://api.gemini.com/v1/book/btcusd?limit_bids=1&limit_asks=1").read
      bid = book["bids"][0]
      ask = book["asks"][0]
      return Quote.new(bid["price"].to_f, bid["amount"].to_f, name),
        Quote.new(ask["price"].to_f, ask["amount"].to_f, name)
    end

    def ticker
      trades = JSON.parse open("https://api.gemini.com/v1/trades/btcusd?limit_trades=1").read
      last_trade = trades[0]
      Ticker.new(
        :last     => last_trade["price"].to_f,
        :volume   => 0.0,
        :high     => 0.0,
        :low      => 0.0,
        :time     => DateTime.now.new_offset(0),
        :exchange => name
      )
    end
  end
end
