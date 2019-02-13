note
	description: "Summary description for {COORDINATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COORDINATE

create
	make

feature -- attributes

	row: INTEGER
	col: INTEGER

	-- define the max row/col for coordinates
	max_row: INTEGER
		once
			Result := 12
		end
	max_col: INTEGER
		once
			Result := 12
		end

feature -- constructors

	make (in: TUPLE [row: INTEGER; col: INTEGER])
		do
			row := in.row
			col := in.col
		ensure
			row = in.row and col = in.col
		end

end
