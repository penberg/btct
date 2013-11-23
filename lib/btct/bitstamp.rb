require 'btct/quote'

require 'open-uri'
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
  end
end
