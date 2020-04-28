---count, place = fun(i, count, place)
local function findOneHole(self, fun)
	local count = 0
	local place = nil
	for i = 1, 3 do
		count, place = fun(i, count, place)
	end
	if count >= 2 and place then
		self.body[place[1]][place[2]] = self.com
		return true
	end
	return false
end

local function playComputer(self)
	local body = self.body
	local pl = self.pl
	local com = self.com

	local is_end = false
	for phase = 1, 2 do
		local str
		if phase == 1 then
			str = com
		else
			str = pl
		end

		for i = 1, 3 do
			is_end = findOneHole(self,function (j, count, place)
				if body[i][j] == str then
					count = count + 1
				elseif body[i][j] == " " then
					place = {i, j}
				end
				return count, place
			end)
			if is_end then return end
		end

		for j = 1, 3 do
			is_end = findOneHole(self, function (i, count, place)
				if body[i][j] == str then
					count = count + 1
				elseif body[i][j] == " " then
					place = {i, j}
				end
				return count, place
			end)
			if is_end then return end
		end

		is_end = findOneHole(self, function (i, count, place)
			if body[i][i] == str then
				count = count + 1
			elseif body[i][i] == " " then
				place = {i, i}
			end
			return count, place
		end)
		if is_end then return end

		is_end = findOneHole(self, function (i, count, place)
			if body[i][4 - i] == str then
				count = count + 1
			elseif body[i][4 - i] == " " then
				place = {i, 4 - i}
			end
			return count, place
		end)
		if is_end then return end
	end



	local blanks = {{}, {}, {}}
	local players = {{}, {}, {}}
	for i = 1, 3 do
		for j = 1, 3 do
			local val = body[i][j]
			if val == " " then
				blanks[i][j] = true
			elseif val == pl then
				players[i][j] = true
			end
		end
	end

	if blanks[1][1] and players[3][3] then
		body[1][1] = com

	elseif blanks[1][3] and players[3][1] then
		body[1][3] = com

	elseif blanks[3][1] and players[1][3] then
		body[3][1] = com

	elseif blanks[3][3] and players[1][1] then
		body[3][3] = com

	elseif blanks[2][2] then
		body[2][2] = com

	elseif blanks[1][1] then
		body[1][1] = com

	elseif blanks[1][3] then
		body[1][3] = com

	elseif blanks[3][1] then
		body[3][1] = com

	elseif blanks[3][3] then
		body[3][3] = com

	elseif blanks[1][2] then
		body[1][2] = com

	elseif blanks[2][1] then
		body[2][1] = com

	elseif blanks[2][3] then
		body[2][3] = com

	elseif blanks[3][2] then
		body[3][2] = com
	end
end

local Board = {}

function Board.new(is_first)
	local obj = {}
	obj.body = {
		{" ", " ", " "},
		{" ", " ", " "},
		{" ", " ", " "}
	}
	if is_first then
		obj.pl = "o"
		obj.com = "x"
	else
		obj.pl = "x"
		obj.com = "o"
	end
	return setmetatable(obj, {__index = Board})
end

local function ioReadIndex()
	print("Where to write?")
	print(" vertical -> 1~3, horizontal -> 1~3")
	print("1 3 <- example")
	local x ,y = io.read("*n", "*n")
	io.read("*l")

	if x == nil or y == nil then
		print("Bad input")
		return ioReadIndex()
	elseif 1 <= x and x <= 3 and 1 <= y and y <= 3 then
		return x, y
	else
		print("Bad input")
		return ioReadIndex()
	end
end

function Board:setVal(is_player_turn)
	if is_player_turn then
		local x, y = ioReadIndex()
		if self.body[x][y] == " " then
			self.body[x][y] = self.pl
		else
			print("Already entered!")
			return self:setVal(is_player_turn)
		end
	else
		return playComputer(self)
	end
end

function Board:print()
	for i = 1, 3 do
		print('"'..table.concat(self.body[i], '"  "')..'"')
	end
end

local function judgeReturn(is_player_turn)
	if is_player_turn then
		return 1
	else
		return 2
	end
end

function Board:judge(is_player_turn)
	local body = self.body

	for i = 1, 3 do
		if body[i][1] ~= " "
		and body[i][2] == body[i][1]
		and body[i][3] == body[i][1] then
			return judgeReturn(is_player_turn)
		end
	end

	for i = 1, 3 do
		if body[1][i] ~= " "
		and body[2][i] == body[1][i]
		and body[3][i] == body[1][i] then
			return judgeReturn(is_player_turn)
		end
	end

	if body[2][2] ~= " " then
		if body[1][1] == body[2][2] and body[3][3] == body[2][2] then
			return judgeReturn(is_player_turn)
		elseif body[1][3] == body[2][2] and body[3][1] == body[2][2] then
			return judgeReturn(is_player_turn)
		end
	end

	return 0
end

return Board