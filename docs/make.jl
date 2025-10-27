using Documenter
using GMC

makedocs(
    sitename = "GMC.jl",
    format = Documenter.HTML(),
    modules = [GMC],
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md"
    ]
)
