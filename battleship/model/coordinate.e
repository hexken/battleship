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

feature -- constructors

	make (inrow: INTEGER; incol: INTEGER)
		do
			row := inrow
			col := incol
		ensure
			row = inrow and col = incol
		end

end
