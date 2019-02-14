note
	description: "Summary description for {SHIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP

create
--	make

feature -- attributes

	size: INTEGER
	health: INTEGER
	coordinates: SET [COORDINATE]
	dir: INTEGER -- 1 vert, 0 horiz

feature -- constructors

	make (insize: INTEGER; coord : COORDINATE; indir: INTEGER)
		require
			insize > 0 and (indir = 0 or indir = 1)
		do
			size := insize
			health := size
		end

invariant
	1 <= size and size <= 12 and (dir = 0 or dir = 1)

end
