note
	description: "Summary description for {MAP_TILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP_TILE

inherit
	ANY
		redefine
			out
		end

create
	make_default, make_occupied

feature -- attribute

	symbol: SHIP_ALPHABET assign set_symbol
	ship: detachable SHIP assign set_ship
	fired_upon: BOOLEAN

feature -- constructor

	make_default
		do
			create symbol.make_blank
			fired_upon := False
		end

	make_occupied (inship: SHIP; debug_mode: BOOLEAN)
		do
			if debug_mode then
				if inship.dir = 1 then
					create symbol.make_vertical
				else
					create symbol.make_horizontal
				end
			else
				create symbol.make_blank
			end

			fired_upon := False
			ship := inship
		end

feature -- commands

	set_fired_upon
		do
			fired_upon := True
			if ship /= Void then
				symbol := create {SHIP_ALPHABET}.make_hit
			else
				symbol := create {SHIP_ALPHABET}.make_miss
			end
		end

	set_symbol (insymbol: SHIP_ALPHABET)
		do
			symbol := insymbol
		ensure
			symbol ~ insymbol
		end

	set_ship (inship: detachable SHIP)
		do
			ship := inship
		ensure
			ship ~ inship
		end

feature -- output

	out: STRING
			-- Return string representation of alphabet.
		do
			Result := symbol.out
		end

invariant
	hit: (ship /= Void and then fired_upon) =  (symbol.item ~ 'X')
	miss:(ship = Void and then fired_upon) = (symbol.item ~ 'O')
	not_fired_upon: (not fired_upon) = (symbol.item ~ '_' or else symbol.item ~ 'h' or else symbol.item ~ 'v')
end
