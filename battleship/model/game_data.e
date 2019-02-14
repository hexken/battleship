note
	description: "The current game map."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_DATA

create{GAME_DATA_ACCESS}
	make

feature{NONE} -- constants

	max_rows: INTEGER
		once
			Result := 12
		end
	max_cols: INTEGER
		once
			Result := 12
		end

feature -- attributes (data)

	level: INTEGER  -- 13 easy, 14 med, 15 hard, 16 advanced
	debug_mode: BOOLEAN -- are we in debug mode?
	game_over: BOOLEAN -- is the current game still on?

	player: PLAYER
	map: MAP
	ships: ARRAY [SHIP]


feature{GAME_DATA_ACCESS} -- constructor

	make (inlevel: INTEGER; indebug_mode: BOOLEAN)
			-- set the game mode, rebase the ETF enums
		require
			game_over: game_over
			level_value: 13 <= inlevel and inlevel <= 16
		do
			level := inlevel - 13
			game_over := False
			debug_mode := indebug_mode
		ensure
			level_set:
				0 <= level and level <= 3 and
				level =  old inlevel - 13

			game_over_set: game_over = False
		end

feature{NONE} -- private game init helpers

end
