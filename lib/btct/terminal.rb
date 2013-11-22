require 'bitstamp'
require 'mtgox'
require 'btce'

require 'open-uri'
require 'curses'

module BTCT
  class Quote
    attr_reader :price, :amount, :exchange

    def initialize(price, amount, exchange)
      @price, @amount, @exchange = price.to_f, amount.to_f, exchange
    end 
  end

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

  class MtGoxAPI
    def name
      "Mt.Gox"
    end

    def top
      bid = MtGox.bids.sort { |x, y| x.price <=> y.price }.last
      ask = MtGox.asks.sort { |x, y| x.price <=> y.price }.first
      return Quote.new(bid.price, bid.amount, name), Quote.new(ask.price, ask.amount, name)
    end
  end

  class TheRockAPI
    def name
      "The Rock"
    end

    def top
      begin
        ob = JSON.parse open("https://www.therocktrading.com/api/orderbook/BTCUSD").read
        bid = ob["bids"].sort { |x, y| x[0].to_f <=> y [0].to_f }.last
        ask = ob["asks"].sort { |x, y| x[0].to_f <=> y [0].to_f }.first
        return Quote.new(bid[0], bid[1], name), Quote.new(ask[0], ask[1], name)
      rescue
        return Quote.new(0.0, 0.0, name), Quote.new(0.0, 0.0, name)
      end
    end
  end

  class Terminal
    def initialize(argv)
    end
 
    def run
      sources = [
        BitstampAPI.new,
        BtceAPI.new,
        CampBxAPI.new,
        MtGoxAPI.new,
        TheRockAPI.new
      ]
      begin
        def onsig(sig)
          Curses.close_screen
          exit sig
        end
        for i in %w[HUP INT QUIT TERM]
          if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
            trap(i) {|sig| onsig(sig) }
          end
        end
        Curses.init_screen
        Curses.nl
        Curses.noecho
        Curses.setpos(0,  0) ; Curses.addstr "BTC/USD"
        Curses.setpos(0, 21) ; Curses.addstr "Bid"
        Curses.setpos(0, 46) ; Curses.addstr "Ask"
        Curses.setpos(1, 14) ; Curses.addstr "Amount       Price"
        Curses.setpos(1, 39) ; Curses.addstr "Price      Amount"
        Curses.refresh
        while true
          bids = Array.new
          asks = Array.new
          sources.each do |source|
            bid, ask = source.top
            bids.push(bid)
            asks.push(ask)
          end
          bids.sort! { |x,y| y.price <=> x.price }
          asks.sort! { |x,y| x.price <=> y.price }
          row = 2
          bids.zip(asks).each do |bid, ask|
            text = "%-10s %10.6f %12.6f  %-12.6f %-10.6f %-10s" % [bid.exchange, bid.amount, bid.price, ask.price, ask.amount, ask.exchange]
            Curses.setpos(row, 0) ; Curses.addstr text
            row = row + 1
          end
          Curses.refresh
          sleep 5
        end
      ensure
        Curses.close_screen
      end
    end
  end
end
