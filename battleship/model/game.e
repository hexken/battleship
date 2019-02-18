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
	first_game_started: BOOLEAN

	game_num: INTEGER
	state : INTEGER
	total_score: INTEGER
	total_max_score: INTEGER

	error_str: STRING
	status_str: STRING

feature -- constructor

	make
		local
			data_access: GAME_DATA_ACCESS
		do
			d := data_access.data
			state := -1
			create error_str.make_from_string (d.ok_str)
			create status_str.make_from_string (d.s1)
		end

feature -- model oprations

	new_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		require
			valid_level: 13 <= inlevel and inlevel <= 16
		do
			if game_in_progress then
				error_str.make_from_string(d.e1)
			else
				d.init (inlevel, indebug_mode)
				total_max_score := total_max_score + d.max_score
				game_in_progress := True
				first_game_started := True
				game_num := game_num + 1
				error_str.make_from_string (d.ok_str)
				status_str.make_from_string (d.s2)
			end
		end

	debug_test (inlevel: INTEGER)
		do
			new_game (inlevel, True)
		end

	fire (row: INTEGER; col: INTEGER)
		do
			status_str.make_empty
			if not game_in_progress then
				error_str.make_from_string(d.e2)
			elseif d.player.out_of_ammo then
				error_str.make_from_string(d.e3)
			elseif not valid_coordinate (row, col) then
				error_str.make_from_string(d.e5)
			elseif d.map.board [row, col].fired_upon then
				error_str.make_from_string(d.e6)
			else
				error_str.make_from_string(d.ok_str)
				d.player.fire
				d.map.board [row, col].set_fired_upon
				-- check if the coordinates are occupied
				if attached d.map.board [row, col].ship as ship then
					ship.hit
					-- check if a ship was sunk
					if ship.health = 0 then
						d.player.increment_ships_sunk
						d.player.increment_score (ship.size)
						total_score := total_score + ship.size
						status_str.make_from_string(d.s8 (ship.size))
					else
						status_str.make_from_string(d.s4)
					end
				else
					-- no hit occurred
					status_str.make_from_string(d.s5)
				end
			end
			-- check for end game conditions
			check_game_over
		end

	bomb (row1, col1, row2, col2: INTEGER)
		local
			ship1: detachable SHIP
			ship2: detachable SHIP
		do
			status_str.make_empty
			if not game_in_progress then
				error_str.make_from_string(d.e2)
			elseif d.player.bombs = 0 then
				error_str.make_from_string(d.e4)
			elseif not adjacent_coordinates (row1, col1, row2, col2) then
				error_str.make_from_string(d.e7)
			elseif not (valid_coordinate (row1, col1) and valid_coordinate (row2, col2)) then
				error_str.make_from_string(d.e5)
			elseif d.map.board [row1, col1].fired_upon or d.map.board [row2, col2].fired_upon then
				error_str.make_from_string(d.e6)
			else
				error_str.make_from_string(d.ok_str)
				d.player.bomb
				-- check for hits
				ship1 := check_bomb_hit (row1, col1)
				ship2 := check_bomb_hit (row2, col2)

				-- both coordinates hit
				if ship1 /= Void and ship2 /= Void then
					if ship1.health = 0 and ship2.health = 0 and then ship1 /= ship2 then
						-- both sunk
						d.player.increment_ships_sunk
						d.player.increment_ships_sunk
						d.player.increment_score (ship1.size + ship2.size)
						total_score := total_score + (ship1.size + ship2.size)
						status_str.make_from_string(d.s9 (ship1.size, ship2.size))

					elseif ship1.health = 0 and (ship2.health /= 0 or ship1 = ship2) then
						 -- 1st coordinates sunk a ship, 2nd did not
						d.player.increment_ships_sunk
						d.player.increment_score (ship1.size)
						total_score := total_score + ship1.size
						status_str.make_from_string(d.s8 (ship1.size))
					elseif (ship1.health /= 0 or ship1 = ship2) and ship2.health = 0 then
						-- 2nd coordinates sunk a ship, 1st did not
						d.player.increment_ships_sunk
						d.player.increment_score (ship2.size)
						total_score := total_score + ship2.size
						status_str.make_from_string(d.s8 (ship2.size))
					else
						-- no sinkages
						status_str.make_from_string(d.s4)
					end
				elseif ship1 /= Void and ship2 = Void then
					-- only 1st coordinates hit
					if ship1.health = 0 then
						d.player.increment_ships_sunk
						d.player.increment_score (ship1.size)
						total_score := total_score + ship1.size
						status_str.make_from_string(d.s8 (ship1.size))
					else
						status_str.make_from_string(d.s4)
					end
				elseif ship1 = Void and ship2 /= Void then
					-- only 2nd coordinates hit
					if ship2.health = 0 then
						d.player.increment_ships_sunk
						d.player.increment_score (ship2.size)
						total_score := total_score + ship2.size
						status_str.make_from_string(d.s8 (ship2.size))
					else
						status_str.make_from_string(d.s4)
					end
				else
					-- no hits
					status_str.make_from_string(d.s5)
				end
			end
			check_game_over
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

	check_game_over
		do
			if not game_in_progress then
				status_str.make_from_string (d.s1)
			elseif d.num_ships = d.player.ships_sunk then
				game_in_progress := False
				status_str.append (d.s6)
			elseif d.player.out_of_ammo and d.player.out_of_bombs then
				game_in_progress := False
				status_str.append (d.s7)
			else
				status_str.append (d.s3)
			end
		end


	check_bomb_hit (row, col: INTEGER): detachable SHIP
		do
			d.map.board [row, col].set_fired_upon
			if attached d.map.board [row, col].ship as ship then
				ship.hit
				Result := ship
			end
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
			Result.append (error_str)
			Result.append (" -> " + status_str)

			if first_game_started then
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




