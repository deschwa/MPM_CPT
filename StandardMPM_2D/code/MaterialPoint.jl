using LinearAlgebra
using StaticArrays

struct Material
    name::Symbol
    density::Float64
    E::Float64
    ν::Float64
end

mutable struct MaterialPoint
    pos::MVector{2, Float64}
    vel::MVector{2, Float64}
    σ::MMatrix{2, 2, Float64}
    F::MMatrix{2, 2, Float64}
    L::MMatrix{2, 2, Float64}
    V::Float64
    mass::Float64
    ρ::Float64
    material::Material
end