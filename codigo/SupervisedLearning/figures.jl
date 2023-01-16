using Random, Plots, DecisionTree, LaTeXStrings, PGFPlotsX

include("../nord.jl")
theme(:ggnord)
# pgfplotsx()

Random.seed!(1)

X = rand(300, 2)
y = (X[:, 1] .> 0.25) .& (X[:, 1] .< 0.75) .& (X[:, 2] .> 0.25) .& (X[:, 2] .< 0.75)

# Randomly flip some labels
mask = shuffle(1:size(X, 1))[end-8:end]
y[mask] .= .~y[mask]

shapes = fill(:circle, size(y))
shapes[y] .= :diamond

push!(y, true)

scatter(X[:, 1], X[:, 2],
    bg = :white,
    zcolor = Float64.(y),
    markershape = shapes,
    legend = :none,
    xlabel = L"X_1",
    ylabel = L"X_2",
    size = (250, 350),
    guidefont = font(9, "Computer Modern"),
    tickfont = font(7, "Computer Modern"),
)

savefig("escrito/img/tree_obs.pdf")
savefig("escrito/img/tree_obs.svg")

# model = DecisionTreeClassifier(max_depth=4)
# fit!(model, X, y)

# print_tree(model, 5)