note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ACCESS

create
	make

feature -- access
	game: GAME

feature{ETF_NEW_GAME, ETF_DEBUG_TEST} -- initialize the game

	make (inlevel: INTEGER; indebug_mode: BOOLEAN)
		once
			create game.make (inlevel, indebug_mode)
		end

invariant
	game = game
end




