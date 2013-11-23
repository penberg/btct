require 'open-uri'

require 'btct/quote'

module BTCT
  class CampBxAPI
    def name
      "CampBX"
    end

    def top
      ob = JSON.parse open("http://campbx.com/api/xdepth.php").read
      bid = ob["Bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
      ask = ob["Asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
      return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
    end
  end
end