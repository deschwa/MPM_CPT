using ..Grid2D
using ..MaterialPoint2D


"""
Compute the linear shape functions and their gradients for a given material point and grid.
Updates the N_I and dNdx_I fields of the material point.
"""
function linear_shape_funcitons!(mp::MaterialPoint,  grid::Grid{Nx, Ny}) where {Nx, Ny}
    dx = grid.dx
    dy = grid.dy

    x_p = mp.pos[1]
    y_p = mp.pos[2]

    for (node_id, indices) in enumerate(mp.nodes)
        i = indices[1]
        j = indices[2]

        x_I = grid.nodes[i, j].pos[1]
        y_I = grid.nodes[i, j].pos[2]

        sf_x = (1 / dx) * (1 - abs(x_p - x_I) / dx)
        sf_y = (1 / dy) * (1 - abs(y_p - y_I) / dy)
        N_I = sf_x * sf_y

        mp.N_I[node_id] = N_I


        dNxdx = -(1 / dx) * sign(x_p - x_I) 
        dNydy = -(1 / dy) * sign(y_p - y_I)

        dNdx = SVector{Float64}(dNxdx * sf_y, dNydy * sf_x)

        mp.dNdx_I[node_id] = dNdx
    end
end



