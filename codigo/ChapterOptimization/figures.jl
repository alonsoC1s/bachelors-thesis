using PGFPlotsX
using LaTeXStrings
using Polyhedra

include("../nord.jl")

theme(:ggnord)
pgfplotsx()

sqrsize = (250, 250)

default(
    legend = false,
    size = sqrsize,
)

# profits(x) = -(x-5)^2 + 25
profits(x) = (15x^2 - 24x + 5)*exp(-x)
profits_prime(x) = exp(-x) * (-29 + 54x - 15x^2) 

# fig:1d-profits
plot(profits, 1, 10,
    xlabel = L"Cardboard area in $cm^2$",
    ylabel = "Profit",
)

savefig("escrito/img/1d-profits.tikz")


# fig:gd-points
function GradientDescentSimple(func, fprime, x0, alpha, tol=1e-5, max_iter=1000)
    xk = x0
    fk = func(xk)
    pk = -fprime(xk)
    # initialize number of steps, save x and f(x)
    num_iter = 0
    curve_x = [xk]
    curve_y = [fk]

    # take steps
    while abs(pk) > tol && num_iter < max_iter
        # calculate new x, f(x), and -f'(x)
        xk = xk + alpha * pk
        fk = func(xk)
        pk = -fprime(xk)
        # increase number of steps by 1, save new x and f(x)
        num_iter += 1
        push!(curve_x, xk)
        push!(curve_y, fk)

    # print results
        if num_iter == max_iter
            println("Gradient descent does not converge.")
        end
    end
    
    return curve_x, curve_y
end

log_x, log_y = GradientDescentSimple(x -> -profits(x), x -> -profits_prime(x), 10.0, 0.7)

shapes = fill(:ltriangle, size(log_x))
shapes[end] = :circle

scatter(log_x, zeros(size(log_x)),
    zcolor = exp.(log_y .+ 10),
    ylims = (-0.5, 0.5),
    # colorbar = true,
    yticks = :none,
    xlabel = "Cardboard area",
    guidefont = font(9, "Computer Modern"),
    tickfont = font(7, "Computer Modern"),
    markershape = shapes,
    markersize = 8,
)

savefig("escrito/img/gd-points.pdf")

# fig:feasible-region
h = HalfSpace([1, 0], 10) ∩
    HalfSpace([0, 1], 10) ∩
    HalfSpace([1, 1], 13) ∩
    HalfSpace([-1, 0], 0) ∩
    HalfSpace([0, -1], 0)

p = polyhedron(h)

plot(p, ratio=:equal,
    xlabel = "Cardboard for boxes",
    ylabel = "Number of envelopes",
    xlims = (-1, 11),
    ylims = (-1, 11),
    alpha = 0.6,
)

savefig("escrito/img/feasible-region.tikz")