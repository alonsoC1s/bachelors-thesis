#Code modified from DecisionMakingProblems.jl under the MIT licence

using Distributions:Categorical

struct State
    name::Symbol
end

struct Action
    name::Symbol
end

struct DiscreteMDP
    𝒮   ::Vector{State}
    𝒜   ::Vector{Action}
    T   ::Union{Array{Float64, 3}, Nothing} # T(s, a, s′)
    # R::Array{Float64, 2} # R(s, a) = ∑_s′ R(s, a, s′) * T(s, a, s′)
    R   ::Function
    γ   ::Float64
end

function transition(mdp::DiscreteMDP, s::Int, a::Int)
    return Categorical(mdp.T[s, a, :])
end

# # Lineworld expl
# 𝒜 = [Action(:forward), Action(:back)]
# 𝒮 = [State(Symbol("Hex", i)) for i = 1:4]
# function R(s::State, a::Action)
#     if a.name === :forward
#         1
#     else
#         -1
#     end
# end

# hw = DiscreteMDP(𝒮, 𝒜, nothing, R, 0.8)

function lookahead(P::DiscreteMDP, U, s::State, a::Action)
    S, R, γ = P.𝒮, P.R, P.γ
    return R(s, a) + γ * sum(U[i] for (i, s′) ∈ enumerate(S))
end

struct ValueFunctionPolicy
    P
    U
end

function greedy(P::DiscreteMDP, U, s::State)
    u, a = findmax(a -> lookahead(P, U, s, a), P.𝒜)
    return (a=a, u=u)
end

(π::ValueFunctionPolicy)(s::State) = π.P.𝒜[greedy(π.P, π.U, s).a]

function tensorform(P::DiscreteMDP)
    𝒮, 𝒜, R = P.𝒮, P.𝒜, P.R
    𝒮′ = eachindex(𝒮)
    𝒜′ = eachindex(𝒜)
    R′ = [R(s, a) for s ∈ 𝒮, a ∈ 𝒜]
    return 𝒮′, 𝒜′, R′
end