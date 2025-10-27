# GMC.jl Documentation

Welcome to the documentation for GMC.jl, a Julia package for computing the Generalized Measure of Correlation.

## Overview

The Generalized Measure of Correlation (GMC) is a dependence measure that accounts for nonlinearity and asymmetry in relationships between variables. Unlike traditional correlation measures, GMC can capture complex dependencies.

## Quick Start

```julia
using GMC

# Generate sample data
X = randn(1000)
Y = 2 * X + 0.5 * randn(1000)

# Calculate GMC
gmc_result = GMC_Y_given_X(X, Y)
```

## Key Features

- Handles nonlinear relationships
- Asymmetric measure: GMC(Y|X) ≠ GMC(X|Y)
- Feature selection capabilities
- Efficient kernel-based estimation
