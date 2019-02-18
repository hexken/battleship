note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOMB
inherit
	ETF_BOMB_INTERFACE
		redefine bomb end
create
	make
feature -- command
	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64] ; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			bomb_precond(coordinate1, coordinate2)
		local
			row1, col1: INTEGER
			row2, col2: INTEGER
    	do
    		row1 := coordinate1.row.to_integer
    		col1 := coordinate1.column.to_integer
    		row2 := coordinate2.row.to_integer
    		col2 := coordinate2.column.to_integer
			-- perform some update on the model state
			model.bomb (row1, col1, row2, col2)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
