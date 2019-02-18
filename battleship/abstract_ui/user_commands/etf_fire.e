note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
		redefine fire end
create
	make
feature -- command
	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			fire_precond(coordinate)
		local
			row, col: INTEGER
    	do
    		row := coordinate.row.to_integer
    		col := coordinate.column.to_integer
			-- perform some update on the model state
			model.fire (row, col)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
