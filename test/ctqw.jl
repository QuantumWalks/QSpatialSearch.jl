@testset "CTQW model check" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQW(g)
  @test QuantumWalk.matrix(ctqw) == ctqw.matrix

  @testset "Default jumping rate" begin
    @test QuantumWalk.jumping_rate(ctqw) ≈ 1./(n-1)
    @test QuantumWalk.jumping_rate(CTQW(Graph(n))) == 1.
    @test_throws AssertionError QuantumWalk.jumping_rate(CTQW(g, :laplacian))
  end
end
