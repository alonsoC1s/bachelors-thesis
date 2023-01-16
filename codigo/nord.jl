using Colors, Plots

# ╔═╡ 467e5de2-7554-4c74-9831-5b6d01065d5a
const polar = [
	colorant"#2E3440",
	colorant"#3B4252",
	colorant"#434C5E",
	colorant"#4C566A"
]

# ╔═╡ 92959e38-14b1-48e5-9007-6027b1ba3b30
const frost = [
	colorant"#8FBCBB",
	colorant"#88C0D0",
	colorant"#81A1C1",
	colorant"#5E81AC"
]

# ╔═╡ d10d1186-1f71-4bc0-a17e-e3ab69d013ba
const blues = [frost; polar[end:-1:1]]

# ╔═╡ c006ff1e-ffaa-4fcc-9394-2172580e677f
const aurora = [
	colorant"#BF616A",
	colorant"#D08770",
	colorant"#EBCB8B",
	colorant"#A3BE8C",
	colorant"#B48EAD"
]

const nord_to_aurora = [aurora[1:3]; frost]

const _nord = PlotThemes.PlotTheme(Dict([:bg => colorant"#363D46"]))

# Modfied from PlotThemes.jl source code

const _ggplot_colors = Dict(
	# :gray92 => RGB(fill(0.92, 3)...), # Original ggplot
	:gray92 => colorant"#E5E9F0",		# Nord style ggplot
    :gray20 => RGB(fill(0.2, 3)...),
    :gray30 => RGB(fill(0.3, 3)...)
    )


const _ggnord = PlotThemes.PlotTheme(Dict([
    ## Background etc
    :bg => :transparent,
    :bginside => _ggplot_colors[:gray92],
    :bglegend => _ggplot_colors[:gray92],
    :fglegend => :white,
    :fgguide => :black,
    :widen=>true,
    ## Palette
    :palette => vcat(frost[end], aurora),
    # :colorgradient => cgrad(blues),
    :colorgradient => cgrad(nord_to_aurora[end:-1:1]),
    ## Axes / Ticks
    #framestyle => :grid,
    #foreground_color_tick => _ggplot_colors[:gray20], # tick color not yet implemented
    :foreground_color_axis => _ggplot_colors[:gray20], # tick color
    :tick_direction=>:out,
    :foreground_color_border =>:white, # axis color
    :foreground_color_text => _ggplot_colors[:gray30], # tick labels
    :gridlinewidth => 1,
    :guidefont => font(10, "Libre Baskerville"),
    #tick label size => *0.8,
    ### Grid
    :foreground_color_grid => :white,
    :gridalpha => 1,
    ### Minor Grid
    :minorgrid => true,
    :minorgridalpha => 1,
    :minorgridlinewidth=>0.5, # * 0.5
    :foreground_color_minor_grid=>:white,
    #foreground_color_minortick=>:white, ## not yet implemented
    :minorticks => 2,
    ## Lines and markers
    :markerstrokealpha => 0,
    :markerstrokewidth => 0 ])
    #showaxis=> :false
)

PlotThemes.add_theme(:ggnord, _ggnord)
