note
	description: "Singleton access to the game data."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GAME_DATA_ACCESS

feature{GAME, MAP, SHIP, PLAYER}
	data: GAME_DATA
		once
			create Result.make
		end

invariant
	data = data
end




