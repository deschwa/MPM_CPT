module GenerateInitialConditions

using CSV
using DataFrames
using YAML
using ..Materials
using StaticArrays
using ..MaterialPoint2D
using ..Grid2D


"""Reads the YAML"""
function read_YAML(YAMLfile::String)
    yaml_data = YAML.load_file(YAMLfile)
    
    # Read grid parameters
    grid_params = yaml_data["grid"]

    # Read time parameters
    time_params = yaml_data["time"]

    # Create Dict with type => Material
    material_dict = Dict{String, AbstractMaterial}()
    for (material_name, material_props) in yaml_data["materials"]
        if material_props["type"] == "LinearElastic"
            material = LinearElastic(
                material_props["E"],
                material_props["nu"],
                material_props["rho"]
            )
        elseif material_props["type"] == "NeoHookean"
            material = NeoHookean(
                material_props["mu"],
                material_props["lambda"],
                material_props["rho"]
            )
        else
            error("Unknown material type: $(material_props["type"])")   
        end
        material_dict[material_name] = material
    end

    return grid_params, time_params, material_dict

end

function read_particles_csv_2D(file::String, material_dict::Dict{String, AbstractMaterial})
    df = CSV.File(file) |> DataFrame

    mps = Vector{MaterialPoint{MaterialType}}()

    for row in eachrow(df)
        pos = MVector{2, Float64}(row[1], row[2])
        vel = MVector{2, Float64}(row[3], row[4])
        m = row[5]
        V = row[6]
        material = material_dict[row[7]]

        push!(mps, MaterialPoint2D.MaterialPoint(pos, vel, m, V, material))
    end

    return mps
end


end