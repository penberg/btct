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

    def ticker
      ticker = JSON.parse open("https://mtgox.com/api/1/BTCUSD/ticker").read
      ticker = ticker["return"]
      Ticker.new(
        :last     => ticker["last"]["value"].to_f,
        :volume   => ticker["vol" ]["value"].to_f,
        :high     => ticker["high"]["value"].to_f,
        :low      => ticker["low" ]["value"].to_f,
        :time     => DateTime.strptime(ticker["now"][0..-7], '%s'),
        :exchange => name
      )
    end
  end
end
