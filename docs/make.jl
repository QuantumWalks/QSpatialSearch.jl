using Documenter
include("../src/QuantumWalk.jl")
using QuantumWalk, LightGraphs	

# same for contributing and license
println(pwd())
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"); remove_destination=true)

makedocs(
    modules     = [QuantumWalk],
    format      = :html,
    sitename    = "QuantumWalk",
    doctest     = false,
    checkdocs   = :exports,
    assets 	= ["assets/logo.ico"],
    pages       = Any[
		"Home"				=> "index.md",
		"Type hierarchy" 		=> "type_hierarchy.md",
		"Exemplary dynamics"		=> Any[
						"Quantum walk simulator"=> "quantum_walk.md",
						"Quantum search"        => "quantum_search.md"],
		"Examplary models"             	=> Any[
						"CTQW model" 		=> "ctqw.md",
						"Szegedy model" 	=> "szegedy.md"],
		"How to make your own types?"	=> Any[
						"New model" 	=> "new_model.md",		
						"New dynamics" 	=> "new_dynamics.md"],
		"Licence"			=> "license.md",
#		"Citing"			=> "citing.md",
#		"Contributing"	                => "contributing.md"
    ]
)

deploydocs(
    deps        = nothing,
    make        = nothing,
    repo        = "github.com/QuantumWalks/QuantumWalk.jl",
    target      = "build",
    julia       = "0.6",
    osname      = "linux"
)


#rm(normpath(@__FILE__, "src/license.md"))