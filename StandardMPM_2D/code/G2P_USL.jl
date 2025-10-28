module G2P_USL


using ..Grid2D
using ..MaterialPoint2D
using StaticArrays


export grid_to_particle!



function grid_to_particle(grid::Grid, mps::Vector{MaterialPoint}, alpha::Float64, dt::Float64)
    for mp in mps
        # Reset acceleration and velocity update
        a_p = MVector{2, Float64}(0.0, 0.0)
        dv_p = MVector{2, Float64}(0.0, 0.0)

        mp.vel .* alpha
        for (node_id, indices) in enumerate(mp.nodes)
            i = indices[1]
            j = indices[2]

            N_I = mp.N_I[node_id]
            dNdx = mp.dNdx_I[node_id]

            node = grid.nodes[i, j]
            
            
            
            mp.vel .+= N_I * (v_new_I - alpha*v_I)
            
            mp.pos .+= dt * N_I * v_new_I

            mp.L .= dNdx * v_new_I'
        end

    end
    
end




end