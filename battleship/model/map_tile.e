note
	description: "Summary description for {MAP_TILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP_TILE

create
	make

feature -- attribute

	symbol: SHIP_ALPHABET assign set_symbol
	ship: detachable SHIP assign set_ship
	occupied: BOOLEAN assign set_occupied
	fired_upon: BOOLEAN assign set_fired_upon

feature -- constructor

	make
		do
			create symbol.make('_')
			occupied := False
			fired_upon := False
		end

feature -- commands

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

	set_occupied (x: BOOLEAN)
		do
			occupied := x
		ensure
			occupied = x
		end

	set_fired_upon (x: BOOLEAN)
		do
			fired_upon := x
		ensure
			fired_upon = x
		end

invariant
	hit: (occupied and fired_upon) =  (symbol.item ~ 'X')
	miss:( not occupied and fired_upon) = (symbol.item ~ 'O')
end
