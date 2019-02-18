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

	symbol: SHIP_ALPHABET
	ship: detachable SHIP

feature -- constructor

	make 
		do
			create symbol.make('_')
		end


end
