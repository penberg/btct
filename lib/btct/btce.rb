require 'btce'

require 'btct/quote'

module BTCT
  class BtceAPI
    def name
      "BTC-E"
    end

    def top
      ob = Btce::PublicAPI.get_btc_usd_depth_json
      bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end
  end
end