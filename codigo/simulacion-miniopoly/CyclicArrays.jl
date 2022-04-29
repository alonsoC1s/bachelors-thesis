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