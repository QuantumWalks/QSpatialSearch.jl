using LightGraphs

module QuantumWalk
using Expokit
using LightGraphs
using Optim

export
    initial_state,
    evolve,
    measure,
    check_qwdynamics



"""
    QuantumWalk

An package for quantum walk and quantum search simulation.

The packaged provides hierarchy of Quantum walk models and their numerical description together
with general function for quantum walk simulation and quantum search evolution. In
particular `CTQW` and `Szegedy` walk models are implemented as an example of continuous
and discrete walk models.

For both continuous and discrete model quantum walk simulator is implemented and
function finding optimal measurement time for quantum search function. For discrete
walk evolution various optimization may be chosen.

Full documentation is available in [GitHub pages](https://quantumwalks.github.io/QuantumWalk.jl/latest/).

"""
QuantumWalk

"""
    measure(qwd::QWDynamics, state[, vertices::Vector{Int}])

Measure `state` according to `qwd`. If `vertices` is provided, probabilities of
given vertices is returned. Otherwise full probability distribution is returned.
Output is of type `Vector{Float64}`.
"""
measure(::Any)

"""
    evolve(qwd::QWDynamics{<:QWModelDiscr}, state)
    evolve(qwd::QWDynamics{<:QWModelCont}, state, time::Real)

Evolve `state` according to `qwd`. For discrete model single-step evolution
is implemented. Type returned is the same as type of `state`.
"""
evolve(::Any)

"""
    check_qwdynamics(qwdtype::Type{<:QWDynamics}, model::QWModel, parameters::Dict{Symbol}, ...)

Checks whetver combination of the arguments creates valid quantum walk dynamics
`qwdtype`.
"""
check_qwdynamics(::Any)



include("type_hierarchy.jl")
include("dynamics.jl")

# dynamics
include("qwsearch/qwsearch.jl")
include("qwevolution/qwevolution.jl")

# models
include("ctqw/ctqw.jl")
include("szegedy/szegedy.jl")

end
