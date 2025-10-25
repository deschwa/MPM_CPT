using LinearAlgebra
using StaticArrays

abstract type AbstractMaterial end

struct LinearElastic <: AbstractMaterial
    E::Float64
    ν::Float64
    density::Float64
    constitutive_model::Function
end

mutable struct MaterialPoint{Material<:AbstractMaterial}
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