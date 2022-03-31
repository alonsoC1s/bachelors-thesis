include("Miniopoly.jl")

using ..Miniopoly
using Logging, DataFrames, CSV

# Disabling logging for performance reasons
Logging.disable_logging(Logging.Info)

function one_game()
	broke = false
	gm = newgame(2, 1_500)

	while !broke
		broke = turn!(gm, true)
	end

	return gm
end

# Running many simulations
function run_simulation()
	Threads.@threads for i = 1:1_000_000
		gm = one_game()
	end
end
