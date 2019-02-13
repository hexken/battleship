note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

create{GAME}
	make

feature -- attributes

	game_data: GAME_DATA
	ships_sunk: INTEGER
	ammo: INTEGER
	bombs: INTEGER
	score: INTEGER

feature{GAME} -- contructor

	make (am: INTEGER; bo: INTEGER)
		require
			am >= 0 and bo >= 0
		local
			game_data_access: GAME_DATA_ACCESS
		do
			game_data := game_data_access.data
			ammo := am
			bombs := bo
		ensure
			ammo = old am and bombs = old bo
		end

feature -- commands

	fire (coordinates: TUPLE [row: INTEGER; col: INTEGER])
		do

		end

--	bomb(coor1: TUPLE

feature -- queries

	no_ammo: BOOLEAN
		do
			Result := ammo = 0
		end

	no_bombs: BOOLEAN
		do
			Result := bombs = 0
		end
end
