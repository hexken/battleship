note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GAME_ACCESS

feature
	game: GAME
		once
			create Result.make
		end

invariant
	game = game
end




