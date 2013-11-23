require 'bitstamp'

require 'btct/quote'

module BTCT
  class BitstampAPI
    def name
      "Bitstamp"
    end

    def top
      ob = JSON.parse Bitstamp::Net.get('/order_book/').body_str
      bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end
  end
end