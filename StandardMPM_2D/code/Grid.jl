module Grid2D

using StaticArrays

export GridNode, Grid

mutable struct GridNode
    pos::SVector{2, Float64}
    v::MVector{2, Float64}
    momentum::MVector{2, Float64}
    f_ext::MVector{2, Float64}
    f_int::MVector{2, Float64}
    
    m::Float64

    indices::SVector{Int64}

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
            indices
        )
    end
end


struct Grid{Nx, Ny}
    nodes::SMatrix{GridNode, Nx, Ny}
    dx::Float64
    dy::Float64
end


function reset_grid_node!(node::GridNode)
    node.v .= 0.0
    node.m = 0.0
    node.momentum .= 0.0
    node.f_ext .= 0.0
    node.f_int .= 0.0
end