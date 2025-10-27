"""
    GMC

Generalized Measure of Correlation (GMC) package for Julia.

Provides tools to compute the Generalized Measure of Correlation (GMC), 
a dependence measure accounting for nonlinearity and asymmetry in the relationship 
between variables. Based on the method proposed by Zheng, Shi, and Zhang (2012).

# References
Zheng, S., Shi, N.Z., & Zhang, Z. (2012).
Generalized Measures of Correlation for Asymmetry, Nonlinearity, and Beyond.
Journal of the American Statistical Association, 107(499), 1239-1252.
"""
module GMCMeasure

using Statistics
using KernelDensity
using LinearAlgebra
using Random

export GMC_Y_given_X, GMC_X_given_Y, GMC_feature_ranking

include("gmc_functions.jl")

end # module
