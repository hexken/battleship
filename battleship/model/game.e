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

	data: detachable GAME_DATA
	game_in_progress: BOOLEAN
	state : INTEGER

feature -- model operations

	make
		do
			state := 0
			game_in_progress := False
		end

	init_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		local
			data_access: GAME_DATA_ACCESS
		do
			data := data_access.data
			check attached data as d
				then
					d.init (inlevel, indebug_mode)
				end

			game_in_progress := True
		end

	fire (row: INTEGER; col: INTEGER)
		do
			state := state + 1
		end

	bomb (row1, row2, col1, col2: INTEGER)
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
			create Result.make_from_string ("  ")
			Result.append ("System State: default model state ")
			Result.append ("(")
			Result.append (state.out)
			Result.append (")")
		end

end




