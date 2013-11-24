require 'btct/ticker'
require 'btct/quote'
require 'open-uri'
require 'json'

module BTCT
  class BtceAPI
    def name
      "BTC-E"
    end

    def top
      ob = JSON.parse open("https://btc-e.com/api/2/btc_usd/depth").read
      bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end

    def ticker
      ticker = JSON.parse open("https://btc-e.com/api/2/btc_usd/ticker/").read
      ticker = ticker["ticker"]
      Ticker.new(
        :last     => ticker["last"   ].to_f,
        :volume   => ticker["vol_cur"].to_f,
        :high     => ticker["high"   ].to_f,
        :low      => ticker["low"    ].to_f,
        :time     => DateTime.strptime(ticker["updated"].to_s, '%s'),
        :exchange => name
      )
    end
  end
end
