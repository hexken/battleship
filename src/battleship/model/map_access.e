note
	description: "Singleton access to the map."
	author: "Ken Tjhia"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MAP_ACCESS

feature{GAME}
	map: MAP
		once
			create Result.make
		end

invariant
	map = map
end




