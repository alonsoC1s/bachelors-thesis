using CSV, DataFrames, DataFramesMeta
using Statistics, StatsPlots
using OhMyREPL

data = CSV.read("simulacion-750k.csv", DataFrame)

# gd = @chain data begin
#         groupby([:square, :mine])
# 		combine(:reward => (x -> (min=minimum(x), avg=mean(x), max=maximum(x), std=std(x))) => AsTable)
#         # groupby(:mine)
#     end

gd = groupby(data, :mine)
