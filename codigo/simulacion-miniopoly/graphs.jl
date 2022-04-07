using CSV, DataFrames, DataFramesMeta
using Statistics, StatsPlots
using OhMyREPL

theme(:ggplot2)

data = CSV.read("simulacion-10k.csv", DataFrame)
@subset!(data, :square .!= 0)

summs = @chain data begin
        @subset :square .!= 0
        groupby([:square, :mine])
		combine(:reward => (x -> (min=minimum(x), avg=mean(x), max=maximum(x), std=std(x))) => AsTable)
        # groupby(:mine)
    end

gd = groupby(data, :mine)

@df gd[1] violin(:square, :reward,
    linewidth=1,
    xlabel="Square",
    ylabel="Average reward when not bought",
    label=:none,
    xticks=1:8,
)

@df gd[2] violin(:square, :reward,
    linewidth=1,
    xlabel="Square",
    ylabel="Average reward when bought",
    label=:none,
    xticks=1:8,
)