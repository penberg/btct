require 'btct/quote'

module BTCT
  class MtGoxAPI
    def name
      "Mt.Gox"
    end

    def top
      result = JSON.parse open("https://mtgox.com/api/1/BTCUSD/depth/fetch").read
      bid = result["return"]["bids"].sort { |x, y| x["price"].to_f <=> y["price"].to_f }.last
      ask = result["return"]["asks"].sort { |x, y| x["price"].to_f <=> y["price"].to_f }.first
      return Quote.new(bid["price"], bid["amount"], name), Quote.new(ask["price"], ask["amount"], name)
    end
  end
end
