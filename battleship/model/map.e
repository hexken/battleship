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

create {GAME_DATA}
	make

feature{GAME, GAME_DATA} -- attributes

	board: ARRAY2[MAP_TILE]
	rows: INTEGER
	cols: INTEGER

	row_indices : ARRAY[CHARACTER]
		once
			Result := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

feature{GAME_DATA} -- constructor

	make
		-- create the map object, board will not be set properly
		do
			create board.make_filled (create {MAP_TILE}.make_default, 1, 1)
		end

	set_empty_board (inrows: INTEGER; incols: INTEGER)
			-- set initial board
		require
			inrows > 0 and incols > 0
		do
			rows := inrows
			cols := incols
			create board.make_filled (create {MAP_TILE}.make_default, rows, cols)
			across 1 |..| rows as r
			loop
				across 1 |..| cols as c
				loop
					board [r.item, c.item] := create {MAP_TILE}.make_default
				end
			end
		ensure
			rows = inrows and cols = incols
		end

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
					Result.append ("  " + board[i.item, j.item].symbol.out)
				end
			end
		end
end




