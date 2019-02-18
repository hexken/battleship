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

	fire (row: INTEGER; col: INTEGER)
		do
			if not game_in_progress then
				status_str := d.e2
			elseif d.player.ammo = 0 then
				status_str := d.e3
			elseif not valid_coordinate (row, col) then
				status_str := d.e5
			elseif d.map.board [row, col].fired_upon then
				status_str := d.e6
			else
				d.player.fire
				msg_str := d.s3
				if attached d.map.board [row, col].ship as ship then
					status_str := d.s4
					ship.hit
					d.map.board [row, col].set_symbol (create {SHIP_ALPHABET}.make ('X'))
				else
					status_str := d.s5
					d.map.board [row, col].set_symbol (create {SHIP_ALPHABET}.make ('O'))
				end
			end
		end

	bomb (row1, col1, row2, col2: INTEGER)
		do
			if not game_in_progress then
				status_str := d.e2
			elseif d.player.bombs = 0 then
				status_str := d.e4
			elseif not adjacent_coordinates (row1, col1, row2, col2) then
				status_str := d.e7
			elseif not (valid_coordinate (row1, col1) and valid_coordinate (row2, col2)) then
				status_str := d.e5
			elseif d.map.board [row1, col1].fired_upon or d.map.board [row2, col2].fired_upon then
				status_str := d.e6
			else
				d.player.bomb
				if attached d.map.board [row, col].ship as ship then
					status_str := d.s4
					msg_str := d.s3
					ship.hit
					d.map.board [row, col].set_symbol (create {SHIP_ALPHABET}.make ('X'))
				else
					status_str := d.s5
					msg_str := d.s3
					d.map.board [row, col].set_symbol (create {SHIP_ALPHABET}.make ('O'))
				end
			end
		end

	reset
		do

		end
feature{NONE} -- private helpers

	valid_coordinate (row, col: INTEGER): BOOLEAN
		do
			Result := (1 <= row and row <= d.board_size) and
					  (1 <= col and col <= d.board_size)
		end

	adjacent_coordinates (row1, col1, row2, col2: INTEGER): BOOLEAN
		do
			Result := (row1 = row2 and (col1 = col2 + 1 or col1 = col2 - 1)) or
					  (col1 = col2 and (row1 = row2 + 1 or row1 = row2 - 1))
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




