using GMCMeasure
using Test
using Random

@testset "GMCMeasure.jl" begin
    # Set seed for reproducibility
    Random.seed!(123)
    
    @testset "Basic GMC calculations" begin
        # Generate test data
        n = 100
        X = randn(n)
        Y = 2 * X + 0.1 * randn(n)  # Linear relationship
        
        # Test GMC_Y_given_X
        gmc_yx = GMC_Y_given_X(X, Y)
        @test gmc_yx isa Float64
        @test gmc_yx > 0  # Should be positive for correlated data
        
        # Test GMC_X_given_Y
        gmc_xy = GMC_X_given_Y(X, Y)
        @test gmc_xy isa Float64
        @test gmc_xy > 0
    end
    
    @testset "Feature ranking" begin
        # Generate test data with multiple features
        n = 100
        X1 = randn(n)
        X2 = randn(n)
        X3 = randn(n)
        Y = 2 * X1 + X2.^2 + 0.1 * randn(n)
        X = hcat(X1, X2, X3)
        
        # Test feature ranking
        ranking = GMC_feature_ranking(X, Y)
        @test length(ranking.Variable) == 3
        @test length(ranking.GMC) == 3
        @test all(ranking.GMC .>= 0)
    end
    
    @testset "Edge cases" begin
        # Test with independent variables
        Random.seed!(456)
        n = 50
        X = randn(n)
        Y = randn(n)  # Independent
        
        gmc_yx = GMC_Y_given_X(X, Y)
        @test gmc_yx isa Float64
        @test abs(gmc_yx) < 0.5  # Should be close to 0 for independent variables
    end
end
