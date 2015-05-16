require 'csv'
require 'json'


class GamePlayer
	attr_accessor :capital, :having_stores,:name ,:masu
	def initialize(name)
		@name = name
		@capital = 200
		@having_stores = []
		@masu = 0
	end

	def bought_store(store_id,price)
		@having_stores.push(store_id)
		@capital -= price.to_i
	end

	def show_pleyer_status()
		p @masu.to_s + " " + @name + " " +  @capital.to_s + " " + having_stores.length.to_s 
		return @masu.to_s + " " + @name + " " +  @capital.to_s + " " + having_stores.length.to_s 
	end
end

class PlayerManager
	attr_accessor :players

	def initialize()
		@players = []
	end

	def join_player(name)
		@players.push(GamePlayer.new(name))
	end

	def get_allplayers()
		puts "---players  capital store_num---"
		@players.each{|p|
			print "  "
			print p.name
			print "   "
			print p.capital
			print "   "
			print p.having_stores.length
			puts 
		}
		puts "----------------------------------"
	end

end

class TurnManager 
	attr_accessor :turn
	def initialize()
   		 @turn = 0
    end

    def gamestart()
    	puts "gamestart! "
    	@turn = 0
    end

    def step_turn()
    	return @turn +=1
    end

end


class Map
	attr_accessor :masues
	def initialize(mapfile)
			line = ':id,:type,:name,:color,:price,:rent'
			header = [:id,:type,:name,:color,:price,:rent]

			csv = File.read(mapfile)

			@masues = []
			CSV(csv).each_with_index do |row, i|
			  
			  @masues[i] = Hash[*[header, row].transpose.flatten]

			  @masues[i][:rent] = @masues[i][:rent].split.map(&:to_i)
			  @masues[i][:who_has] = ""
			  # puts JSON.dump(hash)
			end
	end


	def show_map()
		@masues.each{|st|
				puts st[:name]
		}
	end

	def show_masu(id)
		return @masues[id]
	end

	def buy_store(id,buy_player)
		if @masues[id][:type] == "store" then
			@masues[id][:who_has] = buy_player
			return true
		else
			return false
		end
	end
end


class Dice

	def self.dice_Roll(max_size)
		return rand(max_size) +1
	end

	def self.double_dice_ROll(dicenum,max_size)
		dicesum = 0
		result_dice =[dicenum]

		for i in 1..dicenum do 
			result_dice[i-1] = dice_Roll(max_size)
			dicesum += result_dice[i-1]
		end

		return result_dice,dicesum
	end

end
class GameManager
	attr_accessor :pm
	def initialize()
		@map = Map.new("map.csv")
		# @map.show_@map()
		@pm = PlayerManager.new()
		@tm = TurnManager.new()
		@tm.gamestart()
		@pm.get_allplayers()
	
	end
	def show_status()
		status = []
		puts "---------ゲーム状況------------"
		@pm.players.each_with_index{|p,i|
			print "☆ "
			status[i] = p.show_pleyer_status()
		}
		puts "---------ゲーム状況------------"

		return status
	end
	#ひと通り回すだけ
	def debug_one_turn()

		puts ""

		puts "ターン" + @tm.turn.to_s
		@nowplayer = @pm.players[@tm.turn % @pm.players.length]

		puts @nowplayer.name + "'s turn!"

		puts ""
		puts "DiceRoll!"

		result ,sum =  Dice.double_dice_ROll(2,6)
		# STDIN.gets
		p result
		p "☆☆☆ドン☆☆☆☆    " + sum.to_s + "   ☆☆☆ドン☆☆☆☆"

		@nowplayer.masu = (@nowplayer.masu + sum)% @map.masues.length

		@nowmasu   = @map.masues[@nowplayer.masu]

		puts @nowplayer.name + " go to " 

		puts "------------------"
		@nowmasu.each{|key,value|
			puts key.to_s + ":" + value.to_s
		}
		puts "------------------"
		# puts @nowmasu.to_s

		if @nowmasu[:type] == "store" then
			puts "stop store masu!"
			if @nowmasu[:who_has]=="" then
					puts "you can buy here (y/n)"
					

					# isbuy = STDIN.gets 
					# isbuy.chop!

					#debug
					isbuy ="y"

					if(isbuy.to_s == "y") then
						#if buy
						if(@map.buy_store(@nowplayer.masu,@nowplayer.name)) then
							puts "buy!"
							@nowplayer.bought_store(@nowplayer.masu,@nowmasu[:price])
						end

						p @nowplayer.having_stores
					end

			else 
				puts "this masu is had " + @nowmasu[:who_has]
				puts "minus " + @nowmasu[:price].to_s
				@nowplayer.capital -= @nowmasu[:price].to_i
				@pm.players.each{|p|
					if p.name == @nowmasu[:who_has] then
						p.capital += @nowmasu[:rent][0]
					end
				}
			end
		elsif @nowmasu[:type] == "fund"  then 
			puts "fund"
			#fundの処理 test用
			@nowplayer.capital += Dice.dice_Roll(6) * 50

		elsif @nowmasu[:type] == "chance" then
			puts "chance"
			#fundの処理 test用
			@nowplayer.capital += 100
		end
			

		@tm.step_turn()
	end

end
