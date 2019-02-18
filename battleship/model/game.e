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

feature{NONE} -- model attributes

	d: GAME_DATA

	game_in_progress: BOOLEAN
	game_num: INTEGER
	state : INTEGER
	total_score: INTEGER
	total_max_score: INTEGER
	status_str: STRING
	msg_str: STRING

feature -- constructor

	make
		local
			data_access: GAME_DATA_ACCESS
		do
			d := data_access.data
			state := -1
			status_str := d.ok_string
			msg_str := d.s1
		end

feature -- model oprations

	fire (row: INTEGER; col: INTEGER)
		do

		end

	bomb (row1, col1, row2, col2: INTEGER)
		do
			
		end

	new_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		require
			valid_level: 13 <= inlevel and inlevel <= 16
		do
			if game_in_progress then
				status_str := d.e1
			else
				d.init (inlevel, indebug_mode)
				game_in_progress := True
				game_num := game_num + 1
				total_max_score := total_max_score + d.max_score
				status_str := d.ok_string
				msg_str := d.s2
			end
		end

	debug_test (inlevel: INTEGER)
		do
			new_game (inlevel, True)
		end

	reset
		do

		end

feature -- queries
	out : STRING
		local
			fi: FORMAT_INTEGER
		do
			create fi.make (2)
			fi.right_justify

			state := state + 1
			create Result.make_empty
			Result.append ("  state " + state.out + " ")
			Result.append (status_str)
			Result.append (" -> " + msg_str)

			if game_in_progress then
				Result.append (d.map.out)
				Result.append ("%N  Current Game")
				if d.debug_mode then
					Result.append (" (debug)");
				end
				Result.append (": " + game_num.out)
				Result.append ("%N  Shots: " + (d.max_ammo - d.player.ammo).out + "/" + d.max_ammo.out)
				Result.append ("%N  Bombs: " + (d.max_bombs - d.player.bombs).out + "/" + d.max_bombs.out)
				Result.append ("%N  Score: " + d.player.score.out + "/" + d.max_score.out)
					Result.append (" (Total: " + total_score.out + "/" + total_max_score.out + ")")
				Result.append ("%N  Ships: " + d.player.ships_sunk.out + "/" + d.num_ships.out)

				-- output the ships data
				across
					d.ships as s
				loop
					Result.append ("%N    " + s.item.size.out + "x1: ")

					if d.debug_mode then
						Result.append ("[" + d.map.row_indices [s.item.row].out + "," + fi.formatted (s.item.col) + "]")
						Result.append ("->" + d.map.board [s.item.row, s.item.col].out)

						if s.item.dir = 1 then
							--vertical ship
							across 1 |..| (s.item.size - 1) as j
							loop
								Result.append (";[" + d.map.row_indices [s.item.row + j.item].out + "," + fi.formatted (s.item.col) + "]")
								Result.append ("->" + d.map.board [s.item.row + j.item, s.item.col].out)
							end
						else
							across 1 |..| (s.item.size - 1) as j
							loop
								Result.append (";[" + d.map.row_indices [s.item.row].out + "," + fi.formatted (s.item.col + j.item) + "]")
								Result.append ("->" + d.map.board [s.item.row, s.item.col + j.item].out)
							end
						end
					else
						if s.item.health = 0 then
							Result.append ("Sunk")
						else
							Result.append ("Not Sunk")
						end
					end
				end
			end
		end
end




