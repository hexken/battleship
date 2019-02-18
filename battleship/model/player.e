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
	ammo: INTEGER assign set_ammo
	bombs: INTEGER assign set_bombs
	score: INTEGER

feature{GAME_DATA} -- contructor

	make do end


feature -- commands

	fire
		do
			ammo := ammo - 1
		end

	bomb
		do
			bombs := bombs - 1
		end

	increment_score (x: INTEGER)
		do
			score := score + x
		ensure
			score_positive: score >= 0
			score_inc: score = old score + x
		end

	increment_ships_sunk
		do
			ships_sunk := ships_sunk + 1
		ensure
			ships_sunk = old ships_sunk + 1
		end

	reset (inammo, inbombs: INTEGER)
		do
			ammo := inammo
			bombs := inbombs
			ships_sunk := 0
			score := 0
		end

	set_ammo (inammo: INTEGER)
		require
			inammo > 0
		do
			ammo := inammo
		ensure
			ammo = inammo
		end

	set_bombs (inbombs: INTEGER)
		require
			inbombs > 0
		do
			bombs := inbombs
		ensure
			bombs = inbombs
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
