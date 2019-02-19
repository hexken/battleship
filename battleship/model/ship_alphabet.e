note
	description: "Alphabet allowed to appear on a battleship board."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP_ALPHABET

inherit
	ANY
		redefine
			out
		end

create{MAP_TILE}
	make_hit, make_miss, make_blank, make_horizontal, make_vertical

feature{MAP_TILE} -- constants

	make_hit
		do
			item := 'X'
		end

	make_miss
		do
			item := 'O'
		end

	make_blank
		do
			item := '_'
		end

	make_horizontal
		do
			item := 'h'
		end

	make_vertical
		do
			item := 'v'
		end

feature -- Attributes

	item: CHARACTER


feature -- output

	out: STRING
			-- Return string representation of alphabet.
		do
			Result := item.out
		end

invariant
	allowable_symbols:
		item ~ 'X' or item ~ 'O' or
		item ~ 'v' or item ~ 'h' or item ~ '_'
end
