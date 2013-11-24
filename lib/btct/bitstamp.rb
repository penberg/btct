require 'btct/ticker'
require 'btct/quote'
require 'open-uri'
require 'date'
require 'json'

module BTCT
  class BitstampAPI
    def name
      "Bitstamp"
    end

    def top
      ob = JSON.parse open("https://www.bitstamp.net/api/order_book/").read
      bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end

    def ticker
      ticker = JSON.parse open("https://www.bitstamp.net/api/ticker/").read
      Ticker.new(
        :last     => ticker["last"  ].to_f,
        :volume   => ticker["volume"].to_f,
        :high     => ticker["high"  ].to_f,
        :low      => ticker["low"   ].to_f,
        :time     => DateTime.strptime(ticker["timestamp"], '%s'),
        :exchange => name
      )
    end
  end
end
