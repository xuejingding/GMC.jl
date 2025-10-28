# GMCMeasure.jl

[![Build Status](https://github.com/xuejingding/GMCMeasure.jl/workflows/CI/badge.svg))](https://github.com/xuejingding/GMCMeasure.jl/actions)

A Julia package for computing the Generalized Measure of Correlation (GMC), a dependence measure that accounts for nonlinearity and asymmetry in the relationship between variables.

## Installation

Once registered (after 3 days), install with:
```julia
using Pkg
Pkg.add("GMCMeasure")
```

Currently in registration, you can install from GitHub:
```julia
using Pkg
Pkg.add(url="https://github.com/xuejingding/GMCMeasure.jl")
```

## Quick Start

```julia
using GMCMeasure
using Random

# Generate sample data
Random.seed!(123)
n = 1000
X = randn(n)
Y = 2 * X + 0.5 * randn(n)

# Calculate GMC(Y|X)
gmc_yx = GMC_Y_given_X(X, Y)
println("GMC(Y|X) = ", gmc_yx)

# Calculate GMC(X|Y)  
gmc_xy = GMC_X_given_Y(X, Y)
println("GMC(X|Y) = ", gmc_xy)
```

## Features

- **GMC_Y_given_X(X, Y)**: Compute GMC(Y|X)
- **GMC_X_given_Y(X, Y)**: Compute GMC(X|Y)  
- **GMC_feature_ranking(X, Y)**: Rank features by GMC scores
- Computes Generalized Measure of Correlation
- Handles nonlinear relationships
- Accounts for asymmetry in variable relationships
- Efficient implementation using kernel density estimation

## Example: Feature Selection

```julia
using GMC
using Random

# Generate data with multiple predictors
Random.seed!(123)
n = 500
X1 = randn(n)
X2 = randn(n) 
X3 = randn(n)
Y = 2 * X1 + X2.^2 + 0.5 * randn(n)
X = hcat(X1, X2, X3)

# Rank features by GMC
ranking = GMC_feature_ranking(X, Y)
println("Feature ranking:")
for (var, score) in zip(ranking.Variable, ranking.GMC)
    println("$var: $(round(score, digits=4))")
end
```

## Method

The Generalized Measure of Correlation (GMC) is defined as:

```
GMC(Y|X) = [E[(E[Y|X])²] - (E[Y])²] / Var(Y)
```

This measure:
- Equals 0 when Y and X are independent
- Equals 1 when Y is a deterministic function of X
- Captures both linear and nonlinear dependencies
- Is asymmetric: GMC(Y|X) ≠ GMC(X|Y) in general

## References

Zheng, S., Shi, N.Z., & Zhang, Z. (2012). Generalized Measures of Correlation for Asymmetry, Nonlinearity, and Beyond. *Journal of the American Statistical Association*, 107(499), 1239-1252.

## Citation

If you use GMCMeasure.jl in your research, please cite:
```bibtex
@software{GMCMeasure_jl,
  author = {Ding, Xuejing and Zhang, Zhengjun},
  title = {GMCMeasure.jl: Generalized Measure of Correlation},
  year = {2025},
  url = {https://github.com/xuejingding/GMCMeasure.jl}
}
```

## License

This package is licensed under the MIT License.
