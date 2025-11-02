module Types

using StaticArrays

abstract type AbstractMaterial end


"""
MaterialPoint Type. contains all necessary information about a material point.
"""
mutable struct MaterialPoint{MaterialType<:AbstractMaterial}
    # Vector properties
    pos::MVector{2, Float64}
    vel::MVector{2, Float64}
    ext_force::MVector{2, Float64}
    
    # Scalar properties
    m::Float64
    V::Float64
    V_0::Float64
    ρ::Float64

    # Tensor properties
    F::SMatrix{2,2,Float64,4}
    σ::SMatrix{2,2,Float64,4}
    L::SMatrix{2,2,Float64}

    # Material
    material::MaterialType

    # Grid-related properties to boost performance
    nodes::SVector(4, SVector{2, Int64})
    N_Ip::SVector{4, Float64}
    dNdx_Ip::SVector{4,SVector{Float64}}

    # Constructor with only x, v, m, V and material
    function MaterialPoint(pos::MVector{2, Float64}, vel::MVector{2, Float64}, m::Float64, V::Float64, material::MaterialType) where MaterialType<:AbstractMaterial
        ρ = m / V
        F = @SMatrix [1.0 0.0; 0.0 1.0]
        σ = @SMatrix [0.0 0.0; 0.0 0.0]
        nodes = SVector{4, SVector{2, Float64}}(undef)
        N_I = SVector{4, Float64}(undef)
        dNdx_I = SVector{4, SVector{Float64}}(undef)
        new{MaterialType}(pos, vel, m, V, V, ρ, F, σ, material, nodes, N_I, dNdx_I)
    end
end



mutable struct GridNode
    pos::SVector{2, Float64}
    v::MVector{2, Float64}
    v_new::MVector{2, Float64}
    momentum::MVector{2, Float64}
    momentum_new::MVector{2, Float64}
    f_ext::MVector{2, Float64}
    f_int::MVector{2, Float64}
    
    m::Float64

    indices::SVector{Int64}

    isDirichlet::Bool

    # Constructor using only x,y and indices
    function GridNode(x::Float64, y::Float64, indices::SVector{Int64})
        pos = SVector{2, Float64}(x, y)

        new(
            pos, 
            0.0, 
            MVector{2, Float64}(0.0, 0.0), 
            MVector{2, Float64}(0.0, 0.0), 
            MVector{2, Float64}(0.0, 0.0),
            MVector{2, Float64}(0.0, 0.0), 
            MVector{2, Float64}(0.0, 0.0), 
            MVector{2, Float64}(0.0, 0.0), 
            indices,
            false,
        )
    end
end



mutable struct MPMSimulation{Np, Nx, Ny, MaterialType<:AbstractMaterial}
    material_points::SVector{Np, MaterialPoint{MaterialType}}
    nodes::SMatrix{GridNode, Nx, Ny}
    dx::Float64
    dy::Float64
    dt::Float64
    t::Float64
end



end # module