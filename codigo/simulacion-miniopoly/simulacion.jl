using Distributions


# Cyclic arrays to make iteration simpler
struct CyclicArray{L, T}
    data::NTuple{L,T}
end

# Useful constructors
CyclicArray(x...) = CyclicArray(x)
CyclicArray(x::Vector{}) = CyclicArray(Tuple(x))

function Base.getindex(ca::CyclicArray{L}, i) where {L}
    # Substracting and adding 1 to i because Julia is 1-based indexed
    return ca.data[((i - 1) % L) + 1]
end

function Base.zeros(::Type{CyclicArray{L, T}}) where {L, T}
    return CyclicArray(zeros(T, L))
end


# Constants for bit-masking
const OWNED = 1
const BOT_OWNED = 2
const HAS_HOTEL = 4

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
Dictionary containing probability mass functions that describe
the probabilities of landing on a square, staring on some other
square, which is used as the dict key.

To simulate the spinning action we sample from a DiscreteNonParametric
distribution. For each of these, the support are the numbers from 0 to 8
representing squares from "Start" to 8. The DiscreteNonParametric
distribution from `Distributions` simulates an arbitrary pmf with a
defined support and a vector of probabilities (like the rows of P).

# Examples
Simulating a turn starting on square 2
```julia-repl
rand(square_PMF[2])
```
"""
const square_PMF = Dict(
        [ (i, DiscreteNonParametric(0:8, P[i+1, :])) for i=0:8]
    )

"""
Represents a single square on the board. Designed to work as 
a bit-field. The bits represent in order:
- Wether or not the square is owned.
- If its owned by the bot.
- If it has a hotel.

The square status is obtained by applying bitwise operations on
the `s` field and the predefined constants that indicate wether
or not a specific flag is turned on.

Note: Subtype of Integer so I can box it in a CyclicVector.

# Examples
To check if the square is owned
```julia-repl
Sq = Square(3) # 011 in binary. Both OWNED and BOT_OWNED, but not HAS_HOTEL
(Sq.s & OWNED) != 0 # True

(Sq.s & BOT_OWNED) != 0 # True

(Sq.s & HAS_HOTEL) != 0 # False
```
"""
struct Square <: Integer
    s::UInt8
end

# Outer constructor for default instance
Square() = Square(0)

# Utilty functions

"""
    is_owned(sq::Square)::Bool

Check if `sq` is owned or available for purchase.
"""
function is_owned(sq::Square)::Bool
    return (sq.s & OWNED) != 0
end

"""
    is_bot_owned(sq::Square)::Bool

Check if `sq` is owned by bot.
"""
function is_bot_owned(sq::Square)::Bool
    return is_owned(sq) && (sq.s & BOT_OWNED) != 0
end

"""
    has_hotel(sq::Square)::Bool

Check if `sq` has a hotel
"""
function has_hotel(sq::Square)::Bool
    return  is_owned(sq) && (sq.s & HAS_HOTEL) != 0
end


"""
Defines a a monopoly player. It only keeps track of how much money
it has, and where on the board it is. The rest is kept track of by
the GameManager. See also [`GameManager`](@ref).
"""
mutable struct Player
    money::Int
    position::Int
end

# Default player constructor. Player with 1,500$ on starting square
Player() = Player(1_500, 0)

function spin!(p::Player)
    p.position = square_PMF[p.position]
end

function getsquare(p::Player)
    return p.position
end

# Defining zero so I can make list of players with zeros
Base.zero(::Type{Player}) = Player()

"""
Miniopoly main structure for `N` players.
In charge of the logic of the game, such as yielding turns, keeping
track of the property record, and enforcing transactions.
"""
mutable struct GameManager{N}
    board::CyclicArray{9, Square}
    players::CyclicArray{N, Player}
    turn::Int
end

# Default outer constructor for n_players players
newgame(N) = GameManager{N}(
        #fill(Square(), 9),          # Board of squares
        zeros(CyclicArray{9, Square}),
        #fill(Player(), n_players),  # Vector of players
        zeros(CyclicArray{N, Player}),
        1
    )

function nextplayer(gm::GameManager)
    gm.turn += 1
    return gm.players[gm.turn]
end

# Functions

"""
    turn!(b::Board)

Performs a single turn of the game.
"""
function turn!(gm::GameManager)
    # Get player in turn
    player = nextplayer(gm)

    # Spin the spinner
    spin!(player)
    square = getsquare(player)

    # Check if available, free, etc...
    if is_owned(square)
        if is_bot_owned
        else
        end
    else
    end

    # Carry out transactions
end