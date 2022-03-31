module MiniopolyPieces

export Player, Square, is_owned, hotels, owner, willbuy, logreward!
using Distributions

mutable struct Player
    money::Int
    id::Int
    # TODO: Add buying policy
    # rewardslog::Dict{Tuple{Bool, Position}, Float64}
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
    try
        Qₙ = p.rewardslog[(ismine, sqr)]
        p.rewardslog[(ismine, sqr)] += 2 / n * (reward - Qₙ)
    catch
        p.rewardslog[(ismine, sqr)] = reward
    end
end

# FIXME: Función burda de una política de decisión
function willbuy(p::Player)::Bool
    # Apply buying policy to make a choice
    p = 0.5
    return rand(DiscreteNonParametric([true, false], [p, 1 - p]))
end


### Square
mutable struct Square
    # s::UInt8
    owner::Union{Player,Nothing}
    hotels::Int8
end

# Outer constructor for default instance
Square() = Square(Nothing(), 0)

Base.zero(::Type{Square}) = Square()

function Base.show(io::IO, sq::Square)
    print(io, "Square $(sq.owner)")
end

function Base.show(io::IO, ::MIME"text/plain", sq::Square)
    println(io, "Square ownedby $(sq.owner) w/ $(sq.hotels) hotels")
end

is_owned(sq::Square)::Bool = !isnothing(sq.owner)

hotels(sq::Square)::UInt8 = sq.hotels

owner(sq::Square)::Player = sq.owner


end # MiniopolyPieces