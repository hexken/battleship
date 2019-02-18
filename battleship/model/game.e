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

	d: GAME_DATA
	game_in_progress: BOOLEAN
	game_num: INTEGER
	state : INTEGER
	total_score: INTEGER
	total_max_score: INTEGER
	status_str: STRING
	msg_str: STRING

feature -- model operations

	make
		local
			data_access: GAME_DATA_ACCESS
		do
			d := data_access.data
			state := -1
			game_in_progress := False
			status_str := d.ok_string
			msg_str := d.s1
		end

	init (inlevel: INTEGER; indebug_mode: BOOLEAN)
		do
			d.init (inlevel, indebug_mode)
			game_in_progress := True
			game_num := game_num + 1
		end

	fire (row: INTEGER; col: INTEGER)
		do

		end

	bomb (row1, row2, col1, col2: INTEGER)
		do

		end

	new_game (inlevel: INTEGER; indebug_mode: BOOLEAN)
		do
			init (inlevel, indebug_mode)
			total_max_score := total_max_score + d.max_score
			status_str := d.ok_string
			msg_str := d.s2
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
			Result.append ("  state " + state.out + " ")
			Result.append (status_str)
			Result.append (" -> " + msg_str)

			if game_in_progress then
				Result.append (d.map.out)
				Result.append ("%N  Current Game: " + game_num.out)
				Result.append ("%N  Shots: " + (d.max_ammo - d.player.ammo).out + "/" + d.max_ammo.out)
				Result.append ("%N  Bombs: " + (d.max_bombs - d.player.bombs).out + "/" + d.max_bombs.out)
				Result.append ("%N  Score: " + d.player.score.out + "/" + d.max_score.out)
					Result.append (" (Total: " + total_score.out + "/" + total_max_score.out + ")")
				Result.append ("%N  Ships: " + d.player.ships_sunk.out + "/" + d.num_ships.out)
				across 1 |..| d.num_ships as i
				loop
					Result.append ("%N    " + (d.num_ships - i.item + 1).out + "x1: ")
					if d.ships[i.item].health = 0 then
						Result.append ("Sunk")
					else
						Result.append ("Not Sunk")
					end
				end
			end

		end
end




