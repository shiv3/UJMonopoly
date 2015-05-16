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
		@capital -= price
	end

	def show_pleyer_status()
		p @masu.to_s + " " + @name + " " +  @capital.to_s + " " + having_stores.length.to_s 
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
	def initialize()
			# masues[0] = {:type =>"",:name => "" ,:color => "" ,:price => ,:rent =>[,,,,]}
			@masues = []
			@masues[0] = {:type =>"none",:name => "GO" ,:color => "0" ,:price => 0,:rent =>[0,0,0,0,0],:who_has => ""}
			@masues[1] = {:type =>"store",:name => "地中海（メディタレーニアン）通り" ,:color => "braun" ,:price => 50,:rent =>[50,100,150,200,250],:who_has => ""}
			@masues[2] = {:type =>"fund",:name => "共同基金（コミュニティー・チェスト）" ,:color => "0" ,:price => 0,:rent =>[0,0,0,0,0],:who_has => ""}
			@masues[3] = {:type =>"store",:name => "バルティック通り" ,:color => "braun" ,:price => 50,:rent =>[50,100,150,200,250],:who_has => ""}

			#---------debug(めんどくさい)----------
			for i in 4..50 do 
				@masues[i] = {:type =>"store",:name => "バルティック通り" ,:color => "braun" ,:price => 50,:rent =>[60,100,150,200,250],:who_has => ""}
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
		@map = Map.new()
		# @map.show_@map()
		@pm = PlayerManager.new()
		@tm = TurnManager.new()
		@tm.gamestart()
		@pm.get_allplayers()
	
	end


	def one_turn()

		puts ""

		puts "ターン" + @tm.turn.to_s
		@nowplayer = @pm.players[@tm.turn % @pm.players.length]

		puts @nowplayer.name + "'s turn!"

		puts ""
		puts "DiceRoll!"

		result ,sum =  Dice.double_dice_ROll(2,6)
		p result
		p "☆☆☆ドン☆☆☆☆    " + sum.to_s + "   ☆☆☆ドン☆☆☆☆"

		@nowplayer.masu += sum

		@nowmasu   = @map.masues[@nowplayer.masu]

		puts @nowplayer.name + " go to " 

		puts "------------------"
		@nowmasu.each{|key,value|
			puts key.to_s + ":" + value.to_s
		}
		puts "------------------"
		# puts @nowmasu.to_s

		if @nowmasu[:type] == "store" then
			if @nowmasu[:who_has]=="" then
					puts "you can buy here"
				

				#if buy
				if(@map.buy_store(@nowplayer.masu,@nowplayer.name)) then
					puts "buy!"
					@nowplayer.bought_store(@nowplayer.masu,@nowmasu[:price])
				end

				p @nowplayer.having_stores

			else 
				puts "this masu is had " + @nowmasu[:who_has]
				puts "minus " + @nowmasu[:price].to_s
				@nowplayer.capital -= @nowmasu[:price]
				@pm.players.each{|p|
					if p.name == @nowmasu[:who_has] then
						p.capital += @nowmasu[:rent][0]
					end
				}
			end
		end

		@tm.step_turn()
	end

	def show_status()
		puts "---------ゲーム状況------------"
		@pm.players.each{|p|
			print "☆ "
			p.show_pleyer_status()
		}
		puts "---------ゲーム状況------------"
	end
end


g = GameManager.new()
g.pm.join_player("aa")
g.pm.join_player("kamijo")
g.pm.join_player("dabis")
g.pm.join_player("yamaguchi")
g.pm.join_player("sibazaki")

g.one_turn()
g.one_turn()
g.one_turn()
g.one_turn()
g.one_turn()

g.show_status()

g.one_turn()
g.one_turn()
g.one_turn()
g.one_turn()
g.one_turn()

g.show_status()
