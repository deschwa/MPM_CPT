module P2G


using ..Grid2D
using ..MaterialPoint2D
using StaticArrays
using LinearAlgebra

export particle_to_grid!



function particle_to_grid!(grid::Grid2D, mps::Vector{MaterialPoint})
    # Reset grid node quantities
    reset_grid!(grid)

    # Transfer particle data to grid nodes
    for mp in mps
        # Compute shape functions and their gradients
        find_adjacent_nodes!(mp, grid)
        linear_shape_functions!(mp, grid)

        for (node_id, indices) in enumerate(mp.nodes)
            i = indices[1]
            j = indices[2]

            N_I = mp.N_I[node_id]

            # Mass contribution
            grid.nodes[i, j].m += N_I * mp.m

            # Momentum contribution
            grid.nodes[i, j].p += N_I * mp.m * mp.vel

            # External force contribution
            grid.nodes[i, j].f_ext .+= N_I * mp.m * mp.ext_force

            # Internal force contribution
            dNdx = mp.dNdx_I[node_id]
            grid.nodes[i, j].f_int .-= mp.V * (mp.σ * dNdx)

            
        end

    end
    
end



end

