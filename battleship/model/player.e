note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

create{GAME_DATA}
	make

feature -- attributes

	ships_sunk: INTEGER
	ammo: INTEGER
	bombs: INTEGER
	score: INTEGER

feature{GAME_DATA} -- contructor

	make (am: INTEGER; bo: INTEGER)
		require
			am >= 0 and bo >= 0
		do

			ammo := am
			bombs := bo
		ensure
			ammo = old am and bombs = old bo
		end

feature -- commands

	fire: BOOLEAN
		do
			ammo := ammo - 1
		end

	bomb: BOOLEAN
		do
			bombs := bombs - 1
		end

	increment_ships_sunk
		do
			ships_sunk := ships_sunk + 1
		ensure
			ships_sunk = old ships_sunk + 1
		end


feature -- queries

	out_of_ammo: BOOLEAN
		do
			Result := ammo = 0
		end

	out_of_bombs: BOOLEAN
		do
			Result := bombs = 0
		end

invariant
	bombs >= 0 and ammo >= 0 and ships_sunk >= 0

end
