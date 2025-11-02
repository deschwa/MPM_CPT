module Helpers

using ..Types

function find_adjacent_nodes!(sim::MPMSimulation{Np, Nx, Ny, Material}) where {Np, Nx, Ny, Material}
    dx = sim.dx
    dy = sim.dy

    for (i,mp) in enumerate(sim.material_points)
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
end



function reset_gridnode!(node::GridNode)
    node.m = 0.0
    node.v .= 0.0
    node.v_new .= 0.0
    node.momentum .= 0.0
    node.momentum_new .= 0.0
    node.f_ext .= 0.0
    node.f_int .= 0.0
end


function reset_grid!(sim::MPMSimulation{Np, Nx, Ny, Material}) where {Np, Nx, Ny, Material}
    for (i,j) in CartesianIndices(sim.nodes)
        reset_gridnode!(sim.nodes[i,j])
    end    
end

end