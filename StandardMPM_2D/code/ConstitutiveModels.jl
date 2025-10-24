using StaticArrays
using LinearAlgebra



function linear_elastic_isotropic_stress_update!(mp::MaterialPoint)
    dim = size(mp.σ, 1)
    E = mp.material.E
    ν = mp.material.ν
    λ = (E * ν) / ((1 + ν) * (1 - 2 * ν))
    μ = E / (2 * (1 + ν))
    I = I(dim)
    ε_new = 0.5 * (mp.L + transpose(mp.L))
    tr_ε = tr(ε_new)

    mp.σ .+= λ*tr_ε*I + 2*μ*ε_new

    return
end


function hyperelastic_stress_update!(mp::MaterialPoint)
    dim = size(mp.σ, 1)
    I = I(dim)
    J = det(mp.F)
    E = mp.material.E
    ν = mp.material.ν
    λ = (E * ν) / ((1 + ν) * (1 - 2 * ν))
    μ = E / (2 * (1 + ν))

    mp.σ .= 1/J * (μ*(mp.F * transpose(mp.F) - I) + λ * log(J) * I)

    return
end