include("CyclicArrays.jl")

module Miniopoly

export GameManager, newgame, turn!

using ..CyclicArrays
using Distributions

# Constants for bit-masking & Player setting
# const OWNED = 2^0
const N = 2
# const HAS_HOTEL = 2^(N + 1)
const FLAT_FEE = 250
const SQUARE_PRICE = 350
const HOTEL_PRICE = 100
const INITIAL_MONEY = 1_500
const LAP_REWARD = 200

# Markov chain stochastic transition matrix
const P = [
    #start    1     2     3     4     5    6    7    8
    01/16 001/4 001/4 05/16 01/16 01/16 00000 00000 00000 # Start
    01/16 00000 001/4 05/16 05/16 01/16 00000 00000 00000 # Square 1
    05/16 00000 00000 05/16 05/16 01/16 00000 00000 00000 # Square 2
    001/4 00000 00000 00000 001/4 001/4 001/4 00000 00000 # Square 3
    001/4 00000 00000 00000 00000 001/4 001/4 001/4 00000 # Square 4
    00000 00000 00000 00000 00000 00000 001/4 001/2 001/4 # Square 5
    001/4 00000 00000 00000 00000 00000 00000 001/2 001/4 # Square 6
    001/4 001/4 001/4 00000 00000 00000 00000 00000 001/4 # Square 7
    05/16 001/4 001/4 01/16 01/16 01/16 00000 00000 00000 # Square 8
]

"""
Dictionary containing probability mass functions that describe the probabilities of 
landing on a square, staring on some other square, which is used as the dict key.

To simulate the spinning action we sample from a DiscreteNonParametric distribution. For 
each of these, the support are the numbers from 0 to 8 representing squares from "Start" 
to 8. The DiscreteNonParametric distribution from `Distributions` simulates an arbitrary 
pmf with a defined support and a vector of probabilities (like the rows of P).

# Examples
Simulating a turn starting on square 2
```julia-repl
rand(square_PMF[2])
```
"""
const square_PMF = Dict(
    [(i, DiscreteNonParametric(0:8, P[i+1, :])) for i = 0:8]
)

"""
Defines a a miniopoly player. It only keeps track of how much money it has, and where on 
the board it is. The rest is kept track of by the GameManager. See also 
[`GameManager`](@ref).
"""
mutable struct Player
    money::Int
    id::Int     # Identifier used to check if a square belongs to player
    # TODO: Add buying policy
end

# getsquare(p::Player) = p.position

function moneytransfer!(sender::P, receiver::P, amount::Int)::Bool where {P <: Player}
	_ = transaction!(receiver, amount, :charge)
	return transaction!(sender, amount, :pay)

end

function transaction!(p::Player, amount::Int, direction::Symbol)::Bool
	gone_broke = false
	if direction === :pay
		if p.money - amount < 0
			gone_broke = true
		else
			p.money -= amount
		end
	elseif direction === :charge
		p.money += amount
	end

	return gone_broke
end

# FIXME: Función burda de una política de decisión
function isbuying(p::Player)::Bool
	# Apply buying policy to make a choice
	p = 0.5
	return rand(DiscreteNonParametric([true, false], [p, 1-p]))
end

# Defining zero so I can make list of players with `zeros`
Base.zero(::Type{Player}) = Player(0, 0)

function Base.show(io::IO, ::MIME"text/plain", p::Player)
	print(io, "Player with id $(p.id), \$$(Int(p.money))")
end

"""
Represents a single square on the board. Designed to work as 
a bit-field. The bits represent in order:
- Wether or not the square is owned.
- Who owns it 
- If it has a hotel.

The square status is obtained by applying bitwise operations on the `s` field and the 
predefined constants that indicate wether or not a specific flag is turned on.
"""
mutable struct Square
    # s::UInt8
	owner::Union{Player, Nothing}
	hotels::UInt8
end

# Outer constructor for default instance
Square() = Square(Nothing(), 0)

Base.zero(::Type{Square}) = Square()

"""
    is_owned(sq::Square)::Bool

Check if `sq` is owned or available for purchase.
"""
is_owned(sq::Square)::Bool = !isnothing(sq.owner)

"""
    player_owns(p::Player, sq::Square)::Bool

Check if `sq` is owned by bot.
"""
player_owns(p::Player, sq::Square)::Bool = p == sq.owner

"""
    has_hotel(sq::Square)::Bool

Check if `sq` has a hotel
"""
hotels(sq::Square)::UInt8 = sq.hotels

owner(sq::Square)::Player = sq.owner

buysquare!(sq::Square, p::Player) = sq.owner = p

buyhotel!(sq::Square, p::Player) = sq.hotels += 1

buy!(sq::Square, p::Player, what::Symbol) = what === :square ? buysquare!(sq, p) : buyhotel!(sq, p) 

"""
Miniopoly main structure for `N` players. In charge of the logic of the game, such as 
yielding turns, keeping track of the property record, and enforcing transactions.
"""
mutable struct GameManager{N}
    board::CyclicArray{9,Square}
    players::CyclicArray{N,Player}
    turn::UInt
    positions::Dict{Player,Int}
end

function Base.show(io::IO, ::MIME"text/plain", gm::GameManager{N}) where {N}
	print(io, "Miniopoly, at turn $(gm.turn) with $N players:\nAt positions:\n$(gm.positions)")
end

function newgame(N, initial_money)
    players = zeros(CyclicArray{N,Player})

    gm = GameManager{N}(
        zeros(CyclicArray{9,Square}),  # Board of clean Squares
        players,
        1,      # Turn counter
        Dict(player => 0 for player in players) # Player's positions
    )

    # Initializing players
    for (i, player) in pairs(gm.players)
        player.money = initial_money
        player.id = 2^i
    end

    return gm
end

currentplayer(gm::GameManager) = gm.players[gm.turn]

function spin!(cp::Player, gm::GameManager)
    # Spin the spinner and record the result
    next_square_pos = rand(square_PMF[gm.positions[cp]])

	if next_square_pos == 0
		@info "Player $(cp) just crossed starting point and received $(LAP_REWARD)"
		transaction!(cp, LAP_REWARD, :charge)
	end

    # Update the game manager positions dict
    gm.positions[cp] = next_square_pos

    # Incrementing turn counter
    gm.turn += 1

    return gm.board[next_square_pos + 1] # Correcting 0-based indexing
end

"""
    turn!(gm::GameManager)

Performs a single turn of the game.
"""
function turn!(gm::GameManager)::Bool
    # Get player in turn
    cur_player = currentplayer(gm)

    # Spin the spinner, get new position
    cur_square = spin!(cur_player, gm)

    # Main logic of the game
	gone_broke = false
    if is_owned(cur_square)
        if !player_owns(cur_player, cur_square)
			# Transaction. Charge flat fee * hotel
			amount = FLAT_FEE + 500 * hotels(cur_square)
			@info "Player $(cur_player) landed on owned square and will pay $(amount)"

			gone_broke = moneytransfer!(cur_player, owner(cur_square), amount)
		else
			# Give opportunity to buy hotel
			if isbuying(cur_player)
				@info "Player $(cur_player) will buy a hotel for square $(cur_square)"
				buy!(cur_square, cur_player, :hotel)
				gone_broke = transaction!(cur_player, HOTEL_PRICE, :pay)
			end
        end
    else
		if isbuying(cur_player)
			@info "Player $(cur_player) is buying square $(cur_square)"
			buy!(cur_square, cur_player, :square)
			gone_broke = transaction!(cur_player, SQUARE_PRICE, :pay)
		end
    end

	# Termination conditions
	return gone_broke
end

end # Miniopoly
