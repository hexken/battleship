note
	description: "Singleton access to the game data."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_DATA_ACCESS

create{GAME}
	make

feature{GAME} -- access
	data: GAME_DATA

feature{GAME} -- initilize the data

	make (level: INTEGER; debug_mode: BOOLEAN): GAME_DATA
		once
			Result := data.make (level, debug_mode)
		end

invariant
	data = data
end




