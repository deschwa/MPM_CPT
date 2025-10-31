module GenerateInitialCondition

using CSV
using DataFrames
using ..Materials
using StaticArrays
using ..MaterialPoint2D
using ..Grid2D


function get_material()
    
end

function read_particles_csv_2D(file::String)
    df = CSV.File(file) |> DataFrame

    mps = Vector{MaterialPoint2D.MaterialPoint{MaterialType}}()

    for row in eachrow(df)
        pos = MVector{2, Float64}(row[1], row[2])
        vel = MVector{2, Float64}(row[3], row[4])
        m = row[5]
        V = row[6]
        material = get_material(row[7])

        push!(mps, MaterialPoint2D.MaterialPoint(pos, vel, m, V, material))
    end

    return mps
end


end