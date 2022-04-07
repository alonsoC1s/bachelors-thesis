include("CyclicArrays.jl")
include("MiniopolyPieces.jl")

module Miniopoly

export GameManager, newgame, turn!

using ..CyclicArrays
using ..MiniopolyPieces
using Distributions

# Constants for settings
const N = 2
const FLAT_FEE = 150
const SQUARE_PRICE = 100
const HOTEL_PRICE = 250
const INITIAL_MONEY = 1_500
const SALARY = 150

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

ismine(p::Player, sq::Square)::Bool = p == sq.owner

buysquare!(sq::Square, p::Player) = sq.owner = p

buyhotel!(sq::Square, p::Player) = sq.hotels += 1

function buy!(sq::Square, p::Player, what::Symbol)
	what === :square ? buysquare!(sq, p) : buyhotel!(sq, p)
end

function transaction!(p::Player, sqr::Int, amount::Int, direction::Symbol, n)::Bool
    gone_broke = false

    if direction === :pay
        logreward!(p, sqr, false, -amount, n)

        if p.money - amount < 0
            gone_broke = true
        else
            p.money -= amount
        end
    elseif direction === :charge
        logreward!(p, sqr, true, amount, n)
        p.money += amount
    elseif direction === :squarepurchase
        logreward!(p, sqr, true, amount, n)

        if p.money - amount < 0
            gone_broke = true
        else
            p.money -= amount
        end
    end

    return gone_broke
end

function moneytransfer!(sqr::Int, sender::P, receiver::P, amount::Int, n)::Bool where {P<:Player}
    # Transactions and logging for receiver
    _ = transaction!(receiver, sqr, amount, :charge, n)

    # Transactions and logging for sender
    return transaction!(sender, sqr, amount, :pay, n)
end


function newgame(N, initial_money)
    players = zeros(CyclicArray{N,Player})
    squares = zeros(CyclicArray{9,Square})  # Board of clean Squares

    gm = GameManager{N}(
        squares,
        players,
        1,      # Turn counter
        Dict(player => 0 for player in players) # Player's positions
    )

    # Initializing players
    for (i, player) in pairs(gm.players)
        player.money = initial_money
        player.id = i
    end

    # Numbering squares
    for (i, square) in pairs(gm.board)
        square.id = i-1
    end

    return gm
end

currentplayer(gm::GameManager) = gm.players[gm.turn]

function spin!(cp::Player, gm::GameManager)
    # Spin the spinner and record the result
    next_square_pos = rand(square_PMF[gm.positions[cp]])

    if next_square_pos == 0
        @info "$(cp) just crossed starting point and received $(SALARY)"
		transaction!(cp, gm.positions[cp], 0, :charge, gm.turn)
    end

    # Update the game manager positions dict
    gm.positions[cp] = next_square_pos

    @info "$(cp) landed on square $(next_square_pos)"

    # Incrementing turn counter
    gm.turn += 1

    return gm.board[next_square_pos+1] # Correcting 0-based indexing
end

function turn!(gm::GameManager)::Bool
    @info "Turn: $(gm.turn)"
    cur_player = currentplayer(gm) # Player in turn

    # Spin the spinner, get new position
    cur_square = spin!(cur_player, gm)
    square_number = gm.positions[cur_player] # Supposedly safe from 0-indexing

    @assert cur_square.id == square_number

    # Main logic of the game
    gone_broke = false
    is_mine = ismine(cur_player, cur_square)
    n = gm.turn

	if is_mine
        if willbuy(cur_player, HOTEL_PRICE) && hotels(cur_square) <= 3
            @info "$(cur_player) is buying a hotel for square $(cur_square)"
            buy!(cur_square, cur_player, :hotel)
            gone_broke = transaction!(cur_player, square_number, HOTEL_PRICE, :pay, n)
        end
    else
        # Either already owned, or available to buy
        if is_owned(cur_square)
            # Transaction. Charge flat fee * hotels
            amount = FLAT_FEE + 50 * hotels(cur_square)
            @info "$(cur_player) landed on owned square and will pay $(amount)"

            gone_broke = moneytransfer!(square_number, cur_player, owner(cur_square), amount, n)
        elseif square_number != 0 && willbuy(cur_player, SQUARE_PRICE) # Available for purchase
            @info "$(cur_player) is buying square $(cur_square)"
            buy!(cur_square, cur_player, :square)

            gone_broke = transaction!(cur_player, square_number, SQUARE_PRICE, :squarepurchase, n)
        end
    end

    # Termination conditions
    return gone_broke
end

end # Miniopoly
