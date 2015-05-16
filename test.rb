require './gamemanager.rb'

g = GameManager.new()
g.pm.join_player("aa")
g.pm.join_player("kamijo")
g.pm.join_player("dabis")
g.pm.join_player("yamaguchi")
g.pm.join_player("sibazaki")


for t in 1..20 do
for i in 1..g.pm.players.length do
	g.debug_one_turn()
end
p g.show_status()

end