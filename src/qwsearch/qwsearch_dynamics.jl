export
   execute,
   execute_single,
   execute_single_measured,
   execute_all,
   execute_all_measured


"""
    execute(qss,[ initstate,] runtime[, all, measure])

Run proper execution  of quantum spatial search depending on given keywords.
The initial state is generated by `initial_state(qss)` function if not provided.
`all` and `measure` keywords defaults to `false`. For detailed description
please see documentation of corresponding function. Note that for `all` equal
to `true` model in `qss` needs to be disrete.

"""
function execute(qss::QWSearch,
                 runtime::Real;
                 all::Bool = false,
                 measure::Bool = false)
   if !all && !measure
     execute_single(qss, runtime)
   elseif !all && measure
     execute_single_measured(qss, runtime)
   elseif all && !measure
     execute_all(qss, runtime)
   else
     execute_all_measured(qss, runtime)
   end
end

"""
    execute_single(qss,[ initstate,] runtime)

Evolve `initstate` acording to QWSearch `qss` for time `runtime`.
The initial state is generated by `initial_state(qss)` function if not provided.
`runtime` needs to be nonnegative. If `qss` is based on on `QWModelDiscr`, `runtime`
needs to be `Int`. `QSearchState{S}`, where `S` is the state type, is returned.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> execute_single(qss, 4)
QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623
  [3 ]  =  0.438623
  [4 ]  =  0.438623
  [5 ]  =  0.104937
  [7 ]  =  0.254884
  [8 ]  =  0.254884
  [9 ]  =  0.104937
  [10]  =  0.254884
  [12]  =  0.254884
  [13]  =  0.104937
  [14]  =  0.254884
  [15]  =  0.254884, [0.577169], 4)

```
"""
function execute_single(qss::QWSearch{<:QWModelDiscr},
                        initstate,
                        runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qss, state)
   end

   QSearchState(qss, state, runtime)
end

function execute_single(qss::QWSearch{<:QWModelCont},
                        initstate,
                        runtime::Real)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   QSearchState(qss, evolve(qss, initstate, runtime), runtime)
end

function execute_single(qss::QWSearch, runtime::Real)
   execute_single(qss, initial_state(qss), runtime)
end

"""
    execute_single_measured(qss, [ initstate,] runtime)

Evolve `initstate` acording to QWSearch `qss` for time `runtime`.
The initial state is generated by `initial_state(qss)` function if not provided.
`runtime` needs to be nonnegative. If `qss` is based on on `QWModelDiscr`, `runtime`
needs to be `Int`. Probability measurement distribution is returned.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> execute_single_measured(qss, 4)
4-element Array{Float64,1}:
 0.577169
 0.140944
 0.140944
 0.140944
```
"""
function execute_single_measured(qss::QWSearch, runtime::Real)
   execute_single_measured(qss, initial_state(qss), runtime)
end


"""
    execute_all(qss::QSWSearch{<:QWModelDiscr},[ initstate,] runtime)

Evolve `initstate` acording to QWSearch `qss` for time `runtime`.
`runtime` needs to be nonnegative. The initial state is generated by `initial_state(qss)`
function if not provided. Quantum walk model needs to be discrete.
Returns list of all `QSearchState{S}` where `S` is state type including `initstate`
 and last state.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> execute_all(qss, 2)
3-element Array{QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64},1}:
 QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675
  [3 ]  =  0.288675
  [4 ]  =  0.288675
  [5 ]  =  0.288675
  [7 ]  =  0.288675
  [8 ]  =  0.288675
  [9 ]  =  0.288675
  [10]  =  0.288675
  [12]  =  0.288675
  [13]  =  0.288675
  [14]  =  0.288675
  [15]  =  0.288675, [0.25], 0)
 QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.481125
  [3 ]  =  0.481125
  [4 ]  =  0.481125
  [5 ]  =  -0.288675
  [7 ]  =  -0.096225
  [8 ]  =  -0.096225
  [9 ]  =  -0.288675
  [10]  =  -0.096225
  [12]  =  -0.096225
  [13]  =  -0.288675
  [14]  =  -0.096225
  [15]  =  -0.096225, [0.694444], 1)
 QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  -0.138992
  [3 ]  =  -0.138992
  [4 ]  =  -0.138992
  [5 ]  =  0.032075
  [7 ]  =  -0.395592
  [8 ]  =  -0.395592
  [9 ]  =  0.032075
  [10]  =  -0.395592
  [12]  =  -0.395592
  [13]  =  0.032075
  [14]  =  -0.395592
  [15]  =  -0.395592, [0.0579561], 2)


```
"""
function execute_all(qss::QWSearch{<:QWModelDiscr},
                     initstate::S,
                     runtime::Int) where S
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = Vector{QSearchState{S,Int}}([QSearchState(qss, initstate, 0)])
   state = initstate
   for t=1:runtime
      state = evolve(qss, state)
      push!(result, QSearchState(qss, state, t))
   end

   result
end

function execute_all(qss::QWSearch{<:QWModelDiscr}, runtime::Int)
   execute_all(qss, initial_state(qss), runtime)
end

"""
    execute_all_measured(qss::QWSearch{<:QWModelDiscr},[ initstate,] runtime)

Evolve `initstate` acording to QWSearch `qss` for time `runtime`.
`runtime` needs to be nonnegative. The initial state is generated by `initial_state(qss)`
function if not provided.Quantum walk model needs to be discrete.
As a result return matrix of type `Matrix{Float64}` for which `i`-th column  is
measurement probability distribution in `i-1`-th step.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> execute_all_measured(qss, 2)
4×3 Array{Float64,2}:
 0.25  0.694444  0.0579561
 0.25  0.101852  0.314015
 0.25  0.101852  0.314015
 0.25  0.101852  0.314015


```
"""
function execute_all_measured(qss::QWSearch, runtime::Real)
   execute_all_measured(qss, initial_state(qss), runtime)
end