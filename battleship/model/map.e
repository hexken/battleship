note
	description: "The current game map."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

class
	MAP

inherit
	ANY
		redefine
			out
		end

create {MAP_ACCESS}
	make

feature -- attributes

	board: ARRAY2[SHIP_ALPHABET]
	rows: INTEGER
	cols: INTEGER

	row_indices : ARRAY[CHARACTER]
		once
			Result := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

feature{MAP_ACCESS} -- constructor

	make
			-- defaults to easy mode, if I can use arguments with singleton this would
			-- be unneccsary.
		do
			rows := 4
			cols := 4
			create board.make_filled (create {SHIP_ALPHABET}.make ('_'), rows, cols)
		end

feature{GAME} -- initialization

	init_board (inrows: INTEGER; incols: INTEGER)
			-- set initial board
		do
			rows := inrows
			cols := incols
			create board.make_filled (create {SHIP_ALPHABET}.make ('_'), rows, cols)
		end

--	place_ships ()

feature{GAME} -- utilities

feature{GAME} -- queries

	out: STRING
			-- Return string representation of current game.
			-- You may reuse this routine.
		local
			fi: FORMAT_INTEGER
		do
			create fi.make (2)
			create Result.make_from_string ("%N   ")
			across 1 |..| board.width as i loop Result.append(" " + fi.formatted (i.item)) end
			across 1 |..| board.width as i loop
				Result.append("%N  "+ row_indices[i.item].out)
				across 1 |..| board.height as j loop
					Result.append ("  " + board[i.item,j.item].out)
				end
			end
		end
end




