module MiniopolyPieces

export Player, Square, is_owned, hotels, owner, willbuy, logreward!
using Distributions

mutable struct Player
    money::Int
    id::Int
    rewardslog::Dict{Tuple{Bool,Int},Float64}
end

# Defining zero so I can make list of players with `zeros`
function Base.zero(::Type{Player})
    Player(
        0, # Zero money
        0, # id = 0
        Dict{Tuple{Bool,Int},Float64}() # Empty rewardslog
    )
end

function Base.show(io::IO, p::Player)
    print(io, "Player $(p.id)")
end

function Base.show(io::IO, ::MIME"text/plain", p::Player)
    print(io, "Player #$(p.id), \$$(Int(p.money))")
end

function logreward!(p::Player, sqr::Int, ismine::Bool, reward, n)
	# sqr += 1 # Correcting for 1-based index
    try
        Qₙ = p.rewardslog[(ismine, sqr)]
        p.rewardslog[(ismine, sqr)] += 2 / n * (reward - Qₙ)
    catch
        p.rewardslog[(ismine, sqr)] = reward
    end
end

# FIXME: Función burda de una política de decisión
function willbuy(p::Player, price)::Bool
    # Apply buying policy to make a choice
    q = 0.5
	decision = false
	if p.money - price > 0
		decision = rand(DiscreteNonParametric([true, false], [q, 1 - q]))
	end
	return decision
end


### Square
mutable struct Square
    # s::UInt8
    id::Int
    owner::Union{Player,Nothing}
    hotels::Int8
end

# Outer constructor for default instance
Square() = Square(0, Nothing(), 0)

Base.zero(::Type{Square}) = Square()

function Base.show(io::IO, sq::Square)
    print(io, "Square $(sq.id)")
end

function Base.show(io::IO, ::MIME"text/plain", sq::Square)
    println(io, "Square ownedby $(sq.owner) w/ $(sq.hotels) hotels")
end

is_owned(sq::Square)::Bool = !isnothing(sq.owner)

hotels(sq::Square)::UInt8 = sq.hotels

owner(sq::Square)::Player = sq.owner


end # MiniopolyPieces
