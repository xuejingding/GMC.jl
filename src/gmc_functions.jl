"""
    estimate_EY_X_squared(X, Y; grid_length=10000)

Estimate E[(E[Y|X])^2] using kernel regression with Nadaraya-Watson estimator.

# Arguments
- `X::Vector{Float64}`: Predictor variable
- `Y::Vector{Float64}`: Response variable  
- `grid_length::Int`: Number of grid points for numerical integration

# Returns
- `estimate::Float64`: Estimated value of E[(E[Y|X])^2]
"""
function estimate_EY_X_squared(X::Vector{Float64}, Y::Vector{Float64}; grid_length::Int=10000)
    n = length(X)
    
    # Bandwidth selection using Silverman's rule of thumb
    h = 1.06 * std(X) * n^(-1/5)
    
    # Create grid for integration
    x_min, x_max = extrema(X)
    x_grid = range(x_min - 3*h, x_max + 3*h, length=grid_length)
    delta = step(x_grid)
    
    # Nadaraya-Watson estimator
    EY_grid = zeros(grid_length)
    fx_grid = zeros(grid_length)
    
    for (i, x) in enumerate(x_grid)
        # Compute kernel weights
        weights = exp.(-0.5 * ((X .- x) ./ h).^2) ./ (h * sqrt(2π))
        weight_sum = sum(weights)
        
        if weight_sum > eps()
            EY_grid[i] = sum(weights .* Y) / weight_sum
            fx_grid[i] = weight_sum / n
        end
    end
    
    # Numerical integration
    estimate = sum(EY_grid.^2 .* fx_grid) * delta
    
    return estimate
end

"""
    GMC_Y_given_X(X, Y)

Compute the Generalized Measure of Correlation GMC(Y|X).

# Arguments
- `X::Vector{Float64}`: Predictor variable
- `Y::Vector{Float64}`: Response variable

# Returns
- `Float64`: GMC(Y|X) estimate

# Examples
```julia
# Generate sample data with linear relationship
using Random
Random.seed!(123)
n = 1000
X = randn(n)
Y = 2 * X + 0.5 * randn(n)

# Calculate GMC(Y|X)
gmc_result = GMC_Y_given_X(X, Y)
println(gmc_result)
```
"""
function GMC_Y_given_X(X::Vector{Float64}, Y::Vector{Float64})
    n = length(X)
    h = 1.06 * std(X) * n^(-1/5)
    
    est = estimate_EY_X_squared(X, Y)
    
    # Gaussian kernel moments
    EK = 0.0    # ∫ z K(z) dz = 0
    varK = 1.0  # ∫ z^2 K(z) dz = 1
    
    numerator = est - (mean(Y) + h * EK)^2
    denominator = var(Y) + h^2 * varK
    
    return numerator / denominator
end

"""
    GMC_X_given_Y(X, Y)

Compute the Generalized Measure of Correlation GMC(X|Y).

# Arguments
- `X::Vector{Float64}`: Predictor variable
- `Y::Vector{Float64}`: Response variable

# Returns
- `Float64`: GMC(X|Y) estimate

# Examples
```julia
# Generate sample data with nonlinear relationship
using Random
Random.seed!(123)
n = 1000
X = randn(n)
Y = X.^2 + 0.5 * randn(n)

# Calculate GMC(X|Y)
gmc_result = GMC_X_given_Y(X, Y)
println(gmc_result)
```
"""
function GMC_X_given_Y(X::Vector{Float64}, Y::Vector{Float64})
    return GMC_Y_given_X(Y, X)
end

"""
    GMC_feature_ranking(X, Y; sort=true)

Feature selection using GMC ranking.

# Arguments
- `X::Matrix{Float64}`: Matrix of predictors (n × p)
- `Y::Vector{Float64}`: Response variable
- `sort::Bool`: Whether to sort variables by GMC score

# Returns
- `NamedTuple`: Contains variable names and GMC scores

# Examples
```julia
# Generate sample data with multiple predictors
using Random
Random.seed!(123)
n = 500
X1 = randn(n)
X2 = randn(n)
X3 = randn(n)
Y = 2 * X1 + X2.^2 + 0.5 * randn(n)
X = hcat(X1, X2, X3)

# Rank features by GMC
ranking = GMC_feature_ranking(X, Y)
println(ranking)
```
"""
function GMC_feature_ranking(X::Matrix{Float64}, Y::Vector{Float64}; sort::Bool=true)
    p = size(X, 2)
    gmc_scores = zeros(p)
    
    for j in 1:p
        gmc_scores[j] = GMC_Y_given_X(X[:, j], Y)
    end
    
    variable_names = ["X$i" for i in 1:p]
    
    if sort
        sorted_indices = sortperm(gmc_scores, rev=true)
        return (Variable = variable_names[sorted_indices], GMC = gmc_scores[sorted_indices])
    else
        return (Variable = variable_names, GMC = gmc_scores)
    end
end
