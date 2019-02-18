note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DEBUG_TEST
inherit
	ETF_DEBUG_TEST_INTERFACE
		redefine debug_test end
create
	make
feature -- command
	debug_test(level: INTEGER_64)
		require else
			debug_test_precond(level)
		local
			lvl: INTEGER
    	do
    		lvl := level.to_integer
			-- perform some update on the model state
			model.debug_test(lvl)
			etf_cmd_container.on_change.notify ([Current])
    	end

end
