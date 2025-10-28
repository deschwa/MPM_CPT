

module MaterialPoint2D


using ..Materials
using ..Grid2D
using StaticArrays

export MaterialPoint, find_adjacent_nodes


mutable struct MaterialPoint{MaterialType<:AbstractMaterial}
    pos::MVector{2, Float64}
    vel::MVector{2, Float64}
    ext_force::MVector{2, Float64}
    
    m::Float64
    V::Float64
    ρ::Float64

    F::SMatrix{2,2,Float64,4}
    σ::SMatrix{2,2,Float64,4}
    L::SMatrix{2,2,Float64}

    material::MaterialType

    nodes::SVector(4, SVector{2, Int64})
    N_I::SVector{4, Float64}
    dNdx_I::SVector{4,SVector{Float64}}

    # Constructor with only x, v, m, V and material
    function MaterialPoint(pos::MVector{2, Float64}, vel::MVector{2, Float64}, m::Float64, V::Float64, material::MaterialType) where MaterialType<:AbstractMaterial
        ρ = m / V
        F = @SMatrix [1.0 0.0; 0.0 1.0]
        σ = @SMatrix [0.0 0.0; 0.0 0.0]
        nodes = SVector{4, SVector{2, Float64}}(undef)
        N_I = SVector{4, Float64}(undef)
        dNdx_I = SVector{4, SVector{Float64}}(undef)
        new{MaterialType}(pos, vel, m, V, ρ, F, σ, material, nodes, N_I, dNdx_I)
    end
end


function find_adjacent_nodes!(mp::MaterialPoint, grid::Grid{Nx, Ny}) where {Nx, Ny}
    dx = grid.dx
    dy = grid.dy

    x_p = mp.pos[1]
    y_p = mp.pos[2]

    i = Int(floor(x_p / dx)) + 1
    j = Int(floor(y_p / dy)) + 1

    node_indices = SVector{2, Int64}[
        SVector{2, Int64}(i, j),
        SVector{2, Int64}(i + 1, j),
        SVector{2, Int64}(i, j + 1),
        SVector{2, Int64}(i + 1, j + 1)
    ]

    mp.nodes = node_indices
end


function update_particle!(mps::Vector{MaterialPoint})

end

end