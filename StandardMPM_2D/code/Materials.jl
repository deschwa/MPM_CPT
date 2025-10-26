
module Materials


export AbstractMaterial, LinearElastic, NeoHookean

abstract type AbstractMaterial end


struct LinearElastic <: AbstractMaterial
    E::Float64        # Young's Modulus
    ν::Float64        # Poisson's Ratio
    ρ::Float64        # Density
end


struct NeoHookean <: AbstractMaterial
    μ::Float64        # Shear Modulus
    λ::Float64       # Lamé's First Parameter
    ρ::Float64        # Density
end


end
