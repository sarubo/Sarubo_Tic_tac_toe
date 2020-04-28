local Board = require("Board")

---1ならtrue 2ならfalseを返す
local function question(sentence)
	print(sentence)
	local num = io.read("*n")
	io.read("*l")
	if     num == 1 then
		return true
	elseif num == 2 then
		return false
	else
		print("Bad input")
		return question(sentence)
	end
end

local function main()
	local neither, win, lose = 0, 1, 2
	-- main loop
	while true do
		local want_fight = question("Do you fight?\n  Yes -> 1, No -> 2")
		if not want_fight then
			print("bye!")
			break
		end

		local is_player_turn = question("Are you first?\n  Yes -> 1, No -> 2")
		local board = Board.new(is_player_turn)
		---win = 1, lose = 2, neither = 0
		local status = 0
		for i = 1, 9 do
			if is_player_turn then
				print("Player play")
				board:setVal(is_player_turn)
				board:print()
			else
				print("Computer play")
				board:setVal(is_player_turn)
				board:print()
			end
			status = board:judge(is_player_turn)
			if status ~= neither then
				break
			end
			if is_player_turn then
				is_player_turn = false
			else
				is_player_turn = true
			end
		end
		print(
			(status == win) and "player win"
			or (status == lose) and "player lose"
			or "draw"
		)
	end
end

main()