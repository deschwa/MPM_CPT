using LinearAlgebra
using StaticArrays

mutable struct GridNode
    pos::SVector{2, Float64}
    momentum::MVector{2, Float64}
    vel::MVector{2, Float64}
    mass::Float64
    force_ext::MVector{2, Float64}
    force_int::MVector{2, Float64}
    grid_index::SVector{2, Int}
end


function reset_node!(node::GridNode)
    node.momentum .= 0.0
    node.vel .= 0.0
    node.mass = 0.0
    node.force_ext .= 0.0
    node.force_int .= 0.0
end