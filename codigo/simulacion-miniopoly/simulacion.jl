" Arrays with a fixed length that allow for out-of-index circular indexing"
module CyclicArrays
export CyclicArray

# Cyclic arrays to make iteration simpler
struct CyclicArray{L,T}
    data::NTuple{L,T}
end

# Useful constructors
CyclicArray(x...) = CyclicArray(x)
CyclicArray(x::Vector{}) = CyclicArray(Tuple(x))

function Base.getindex(ca::CyclicArray{L}, i) where {L}
    # Substracting and adding 1 to i because Julia is 1-based indexed
    return ca.data[((i-1)%L)+1]
end

function Base.zeros(::Type{CyclicArray{L,T}}) where {L,T}
    return CyclicArray([zero(T) for i = 1:L]) # Hack so items dont share memory
end

Base.pairs(ca::CyclicArray) = pairs(ca.data)

Base.length(ca::CyclicArray) = length(ca.data)

function Base.iterate(ca::CyclicArray{L}, state = 1) where {L}
    return state > L ? nothing : (ca[state], state + 1)
end

function Base.show(io::IO, ::MIME"text/plain", ca::CyclicArray{L,T}) where {L,T}
    print(io, "CyclicArray{$T} of length $L:\n   ", ca.data)
end

end #CyclicArrays

"Definitions for board and players for Miniopoly"
module MiniopolySimulator

export square_PMF
export GameManager, newgame, currentplayer, spin!

using ..CyclicArrays
using Distributions

# Constants for bit-masking & Player setting
const OWNED = 2^0
const N = 2
const HAS_HOTEL = 2^(N + 1)

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
Defines a a monopoly player. It only keeps track of how much money it has, and where on 
the board it is. The rest is kept track of by the GameManager. See also 
[`GameManager`](@ref).
"""
mutable struct Player
    money::Int
    id::Int     # Identifier used to check if a square belongs to player
end

getsquare(p::Player) = p.position

# Defining zero so I can make list of players with `zeros`
Base.zero(::Type{Player}) = Player(0, 0)

function Base.show(io::IO, ::MIME"text/plain", p::Player)
    print(io, "Player with key $(p.id), \$$(p.money)")
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
struct Square <: Integer
    s::UInt8
end

# Outer constructor for default instance
Square() = Square(0)

Base.zero(::Square) = Square(0)

"""
    is_owned(sq::Square)::Bool

Check if `sq` is owned or available for purchase.
"""
is_owned(sq::Square)::Bool = (sq.s & OWNED) != 0

"""
    player_owns(p::Player, sq::Square)::Bool

Check if `sq` is owned by bot.
"""
player_owns(p::Player, sq::Square)::Bool = s_owned(sq) && (sq.s & p.id) != 0

"""
    has_hotel(sq::Square)::Bool

Check if `sq` has a hotel
"""
has_hotel(sq::Square)::Bool = is_owned(sq) && (sq.s & HAS_HOTEL) != 0

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
    print(io, "Miniopoly, with $N players:\nAt positions:\n$(gm.positions)")
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

nextturn!(gm::GameManager) = gm.turn += 1

currentplayer(gm::GameManager) = gm.players[gm.turn]

function spin!(cp::Player, gm::GameManager)
    # Spin the spinner and record the result
    next_square_pos = rand(square_PMF[gm.positions[cp]])

    # Update the game manager positions dict
    gm.positions[cp] = next_square_pos

    return gm.board[next_square_pos]
end

"""
    turn!(gm::GameManager)

Performs a single turn of the game.
"""
function turn!(gm::GameManager)
    # Get player in turn
    cur_player = currentplayer(gm)

    # Spin the spinner, get new position
    cur_square = spin!(cur_player, gm)

    # Main logic of the game
    if is_owned(cur_square)
        if !player_owns(cur_player, cur_square)
        end
    else
        # Apply buying policy
    end

    # Carry out transactions
end

end # MiniopolySimulator
