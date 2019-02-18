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

	rand_gen: RANDOM_GENERATOR
			-- random generator for normal mode
			-- it's important to keep this as an attribute
		attribute
			create result.make_random
		end

	debug_gen: RANDOM_GENERATOR
			-- deterministic generator for debug mode
			-- it's important to keep this as an attribute
		attribute
			create result.make_debug
		end

	player: PLAYER
	map: MAP
	ships: ARRAYED_LIST [SHIP]


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


	generate_ships (is_debug_mode: BOOLEAN; board_size: INTEGER; num_ships: INTEGER): ARRAYED_LIST[SHIP]
			-- places the ships on the board
			-- either deterministicly random or completely random depending on debug mode
		local
			size: INTEGER
			c,r : INTEGER
			d: BOOLEAN
			gen: RANDOM_GENERATOR
			new_ship: SHIP
		do
			create Result.make (num_ships)
			if is_debug_mode then
				gen := debug_gen
			else
				gen := rand_gen
			end
			from
				size := num_ships
			until
				size = 0
			loop
				d := gen.direction \\ 2
				if d = 1 then
					c := (gen.column \\ board_size) + 1
					r := (gen.row \\ (board_size - size)) + 1
				else
					r := (gen.row \\ board_size) + 1
					c := (gen.column \\ (board_size - size)) + 1
				end

				new_ship.make (size, r, c, d)

				if not collide_with (Result, new_ship) then
					-- If the generated ship does not collide with
					-- ones that have been generated, then
					-- add it to the set.
					Result.extend (new_ship)
					size := size - 1
				end
				gen.forth
			end
		ensure
			-- not sure how to best check this
		end

	collide_with_each_other (ship1, ship2: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
				-- Does `ship1' collide with `ship2'?
			local
				ship1_head_row, ship1_head_col, ship1_tail_row, ship1_tail_col: INTEGER
				ship2_head_row, ship2_head_col, ship2_tail_row, ship2_tail_col: INTEGER
			do
					ship1_tail_row := ship1.row
					ship1_tail_col := ship1.col
					if ship1.dir then
						ship1_tail_row := ship1_tail_row + 1
						ship1_head_row := ship1_tail_row + ship1.size - 1
						ship1_head_col := ship1_tail_col
					else
						ship1_tail_col := ship1_tail_col + 1
						ship1_head_col := ship1_tail_col + ship1.size - 1
						ship1_head_row := ship1_tail_row
					end

					ship2_tail_row := ship2.row
					ship2_tail_col := ship2.col
					if ship2.dir then
						ship2_tail_row := ship2_tail_row + 1
						ship2_head_row := ship2_tail_row + ship2.size - 1
						ship2_head_col := ship2_tail_col
					else
						ship2_tail_col := ship2_tail_col + 1
						ship2_head_col := ship2_tail_col + ship2.size - 1
						ship2_head_row := ship2_tail_row
					end

					Result :=
						ship1_tail_col <= ship2_head_col and then
 						ship1_head_col >= ship2_tail_col and then
 						ship1_tail_row <= ship2_head_row and then
 						ship1_head_row >= ship2_tail_row
			end

	collide_with (existing_ships: ARRAYED_LIST[TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]];
		new_ship: TUPLE[size: INTEGER; row: INTEGER; col: INTEGER; dir: BOOLEAN]): BOOLEAN
				-- Does `new_ship' collide with the set of `existing_ships'?
			do
					across
						existing_ships as existing_ship
					loop
						Result := Result or collide_with_each_other (new_ship, existing_ship.item)
					end
			ensure
				Result =
					across existing_ships as existing_ship
					some
						collide_with_each_other (new_ship, existing_ship.item)
					end
			end

end
