note
	description: "The current game map."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_DATA

create{GAME_DATA_ACCESS}
	make

feature -- attributes

	mode: INTEGER assign set_mode -- 13 easy, 14 med, 15 hard, 16 advanced
	max_rows: INTEGER
	max_cols: INTEGER

feature{GAME_DATA_ACCESS} -- constructor

	make
		do

		end

feature -- initilization

	set_mode (inmode: INTEGER)
			-- set the game mode, rebase the ETF enums
		require
			13 <= inmode and inmode <= 16
		once
			mode := inmode - 13
		ensure
			0 <= mode and mode <= 3 and
			mode =  old inmode - 13
		end

	set_max_rows (rows: INTEGER)
			-- set the max rows
		require
			1 <= rows and rows <= 12
		once
			max_rows := rows
		ensure
			max_rows = old rows
		end

	set_max_cols (cols: INTEGER)
			-- set the max cols
		require
			1 <= cols and cols <= 12
		once
			max_cols := cols
		ensure
			max_cols = old cols
		end
end
