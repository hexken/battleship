note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME

inherit
	ANY
		redefine
			out
		end

create {GAME_ACCESS}
	make

feature -- model attributes

	data: GAME_DATA
	game_in_progress: BOOLEAN
	state : INTEGER

feature -- model operations

	make
		local
			data_access: GAME_DATA_ACCESS
		do
			data := data_access.data
			state := -1
			game_in_progress := False

		end

	init_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		do
			data.init (inlevel, indebug_mode)
			game_in_progress := True
		end

	fire (row: INTEGER; col: INTEGER)
		do

		end

	bomb (row1, row2, col1, col2: INTEGER)
		do

		end

	new_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		do
			init_game (inlevel, indebug_mode)
		end

	debug_test (inlevel: INTEGER; indebug_mode: BOOLEAN)
		do

		end

	default_update
		do
			state := state + 1
		end

	reset
		do

		end

feature -- queries
	out : STRING
		do
			state := state + 1
			create Result.make_empty
			Result.append ("state ")
			Result.append (state.out)
			Result.append (data.map.out)
		end

end




