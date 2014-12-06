module CasaCore

# Tables
export Table
export getColumn, putColumn

# Measures
export ReferenceFrame
export set!
export Measure,Quantity
export measure,observatory

# TODO: Check to make sure this file exists
include("../deps/deps.jl")

include("conversions.jl")
include("containers.jl")
include("tables.jl")
include("measures.jl")

end

