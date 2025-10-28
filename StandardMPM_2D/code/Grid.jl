module Grid2D

using StaticArrays

export GridNode, Grid

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


struct Grid{Nx, Ny}
    nodes::SMatrix{GridNode, Nx, Ny}
    dx::Float64
    dy::Float64
end


function reset_grid_node!(node::GridNode)
    node.v .= 0.0
    node.v_new .= 0.0
    node.m = 0.0
    node.momentum .= 0.0
    node.f_ext .= 0.0
    node.f_int .= 0.0
end




function reset_grid!(grid::Grid)
    for (i,j) in CartesianIndices(grid.nodes)
        reset_grid_node!(grid.nodes[i,j])
    end    
end

function get_grid_velocities!(grid::Grid, cutoff)
    for node in grid.nodes
        node.v_I .= node.momentum / node.Mass
        
        if node.Mass > cutoff
            node.v_new_I .= node.momentum_new / node.mass
        else
            node.v_new_I .= 0
        end
    end
end

function update_momenta!(grid::Grid, dt)
    for node in grid.nodes
        node.momentum_new .= node.momentum + dt * (node.f_ext + node.f_int)
    end
end


function fix_dirichlet_nodes!(grid::Grid)
    for node in grid.nodes
        if node.isDirichlet
            node.momentum .= 0
            node.momentum_new .=0
        end
    end
end

end