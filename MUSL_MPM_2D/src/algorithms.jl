module Algorithms

using ..Types
using ..Helpers
using StaticArrays


function P2G(simulation::MPMSimulation)
    reset_grid!(simulation)
    linear_shape_funcitons!(simulation)

    for mp in simulation.material_points
        for (node_id, indices) in enumerate(mp.nodes)
            i = indices[1]
            j = indices[2]

            N_I = mp.N_I[node_id]
            dNdx_I = mp.dNdx_I[node_id]

            node = simulation.nodes[i, j]

            # Mass
            node.m += N_I * mp.m

            # Momentum
            node.momentum .+= N_I * mp.m * mp.vel

            # External force
            node.f_ext .+= N_I * mp.ext_force

            # Internal force
            node.f_int .-= mp.V * (mp.σ * dNdx_I)
        end
    end
    
end

function update_momenta(sim::MPMSimulation)
    for (i,j) in CartesianIndices(sim.nodes)
        node = sim.nodes[i,j]
       
        # Calculate new momentum
        node.momentum_new .= node.momentum + sim.dt * (node.f_ext + node.f_int)
        
    end
end


function double_mapping(sim::MPMSimulation)
    for (i,j) in CartesianIndices(sim.nodes)
        node = sim.nodes[i,j]
       
        # Calculate new velocity
        node.v_new .= node.momentum_new / node.m
    end

    for mp in sim.material_points
        for (node_id, indices) in enumerate(mp.nodes)
            i = indices[1]
            j = indices[2]

            N_I = mp.N_I[node_id]

            node = sim.nodes[i, j]

            # Update particle velocity
            mp.pos .+= sim.dt * N_I * (node.v_new - node.v) 
        end
    end

    linear_shape_funcitons!(sim)

    
    
end


end