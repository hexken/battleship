note
	description: "Summary description for {SHIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP

create{GAME_DATA}
	make

feature -- attributes

	size: INTEGER
	health: INTEGER
	row: INTEGER
	col: INTEGER
	dir: INTEGER -- 1 vert, 0 horiz

feature{GAME_DATA} -- constructors

	make (insize: INTEGER; inrow: INTEGER; incol: INTEGER; indir: INTEGER)
		require
			valid_size: insize > 0
			valid_dir: indir = 0 or indir = 1
			valid_coords: inrow >=0 and incol >= 0
		do
			size := insize
			health := size
			row := inrow
			col := incol
			dir := indir
		ensure
			size = insize and health = size and
			row = inrow and col = incol and dir = indir
		end

invariant
	valid_size: size > 0
	valid_dir: dir = 0 or dir = 1
	valid_coords: row >=0 and col >= 0
	valid_health: health >= 0

end
