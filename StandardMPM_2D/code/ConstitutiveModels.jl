module ConstitutiveModels

using ..Materials
using ..MaterialPoint
using StaticArrays
using LinearAlgebra


export stress_update!


function stress_update!(mp::MaterialPoint{LinearElastic})
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






end