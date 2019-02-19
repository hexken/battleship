note
	description: "The current game map."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_DATA

create{GAME_DATA_ACCESS}
	make

feature{GAME} -- error strings

	e1: STRING
		once
			Result := "Game already started"
		end

	e2: STRING
		once
			Result := "Game not started"
		end

	e3: STRING
		once
			Result := "No shots remaining"
		end

	e4: STRING
		once
			Result := "No bombs remaining"
		end

	e5: STRING
		once
			Result := "Invalid coordinate"
		end

	e6: STRING
		once
			Result := "Already fired there"
		end

	e7: STRING
		once
			Result := "Bomb coordinates must be adjacent"
		end

feature{GAME} -- Game messages

	s1: STRING
		once
			Result := "Start a new game"
		end

	s2: STRING
		once
			Result := "Fire Away!"
		end

	s3: STRING
		once
			Result := "Keep Firing!"
		end

	s4: STRING
		once
			Result := "Hit! "
		end

	s5: STRING
		once
			Result := "Miss! "
		end

	s6: STRING
		once
			Result := "You Win!"
		end

	s7: STRING
		once
			Result := "Game Over!"
		end

	s8 (sz: INTEGER): STRING
		require
			sz > 0
		do
			Result := sz.out + "x1 ship sunk! "
		end

	s9 (sz1, sz2: INTEGER): STRING
		require
			sz1 > 0 and sz2 > 0
		do
			Result := sz1.out + "x1 and " + sz2.out + "x1 ships sunk! "
		end

	ok_str: STRING
		once
			Result := "OK"
		end

feature{GAME} -- attributes (data)

	level: INTEGER  -- 0 easy, 1 med, 2 hard, 3 advanced
	board_size: INTEGER
	num_ships: INTEGER
	max_score: INTEGER
	max_ammo: INTEGER
	max_bombs: INTEGER

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
	ships:  ARRAYED_LIST [SHIP]


feature{GAME_DATA_ACCESS} -- constructor

	make
		do
			create ships.make (2)
			create player.make
			create map.make
		end

feature{GAME} -- init the data

	init (inlevel: INTEGER; indebug_mode: BOOLEAN)
			-- set the game mode, rebase the ETF enums
		require
			valid_level: 13 <= inlevel and inlevel <= 16
		do
			level := inlevel - 13

			inspect level
			when 0 then
				board_size := 4
				max_score := 3
				num_ships := 2
				max_ammo := 8
				max_bombs := 2
			when 1 then
				board_size := 6
				max_score := 6
				num_ships := 3
				max_ammo := 16
				max_bombs := 3
			when 2 then
				board_size := 8
				max_score := 15
				num_ships := 5
				max_ammo := 24
				max_bombs := 5
			when 3 then
				board_size := 12
				max_score := 28
				num_ships := 7
				max_ammo := 40
				max_bombs := 7
			end

			player.reset (max_ammo, max_bombs)
			map.set_empty_board (board_size, board_size)
			generate_ships (indebug_mode)
			place_new_ships (indebug_mode)
		ensure
			level_set:
				0 <= level and level <= 3 and
				level =  old inlevel - 13
		end

feature{NONE} -- private data init helpers


	generate_ships (debug_mode: BOOLEAN)
			-- places the ships on the board
			-- either deterministicly random or completely random depending on debug mode
		local
			size: INTEGER
			c,r : INTEGER
			d: INTEGER
			gen: RANDOM_GENERATOR
			new_ship: SHIP
		do
			create ships.make (num_ships)
			if debug_mode then
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
					create new_ship.make (size, r + 1, c, d)
				else
					r := (gen.row \\ board_size) + 1
					c := (gen.column \\ (board_size - size)) + 1
					create new_ship.make (size, r, c + 1, d)
				end

				if not collide_with (new_ship) then
					-- If the generated ship does not collide with
					-- ones that have been generated, then
					-- add it to the set.
					ships.extend (new_ship)
					size := size - 1
				end
				gen.forth
			end
		ensure
			-- not sure how to best check this
		end

	collide_with_each_other (ship1, ship2: SHIP): BOOLEAN
				-- Does `ship1' collide with `ship2'?
		local
			ship1_head_row, ship1_head_col, ship1_tail_row, ship1_tail_col: INTEGER
			ship2_head_row, ship2_head_col, ship2_tail_row, ship2_tail_col: INTEGER
		do
				ship1_tail_row := ship1.row
				ship1_tail_col := ship1.col
				if ship1.dir = 1 then
					ship1_head_row := ship1_tail_row + ship1.size - 1
					ship1_head_col := ship1_tail_col
				else
					ship1_head_col := ship1_tail_col + ship1.size - 1
					ship1_head_row := ship1_tail_row
				end

				ship2_tail_row := ship2.row
				ship2_tail_col := ship2.col
				if ship2.dir = 1 then
					ship2_head_row := ship2_tail_row + ship2.size - 1
					ship2_head_col := ship2_tail_col
				else
					ship2_head_col := ship2_tail_col + ship2.size - 1
					ship2_head_row := ship2_tail_row
				end

				Result :=
					ship1_tail_col <= ship2_head_col and then
 						ship1_head_col >= ship2_tail_col and then
 						ship1_tail_row <= ship2_head_row and then
 						ship1_head_row >= ship2_tail_row
		end

	collide_with (new_ship: SHIP): BOOLEAN
				-- Does `new_ship' collide with the set of `existing_ships'?
		do
			across
				ships as existing_ship
			loop
				Result := Result or collide_with_each_other (new_ship, existing_ship.item)
			end
		ensure
			Result =
					across (old ships.deep_twin) as existing_ship
					some
						collide_with_each_other (new_ship, existing_ship.item)
					end
		end

	place_new_ships (indebug_mode: BOOLEAN)
			-- Place the randomly generated positions of `new_ships' onto the `board'.
			-- beginning at ship.row, ship.col
		require
				across ships.lower |..| ships.upper as i all
					across ships.lower |..| ships.upper as j all
						i.item /= j.item implies not collide_with_each_other (ships[i.item], ships[j.item])
					end
				end
		do
			across
				ships as s
			loop
				if s.item.dir = 1 then
					-- Vertical ship
					across
						0 |..| (s.item.size - 1) as i
					loop
						map.board[s.item.row + i.item, s.item.col].make_occupied (s.item, indebug_mode)
					end
				else
					-- Horizontal ship
					across
						0 |..| (s.item.size - 1) as i
					loop
						map.board[s.item.row, s.item.col + i.item].make_occupied (s.item, indebug_mode)
					end
				end
			end
		end

end
