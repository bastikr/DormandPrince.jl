using Base.Test
using DormandPrince

tolerances = [1e-3, 1e-5, 1e-7, 1e-9, 1e-12]

μ = 0.012277471

# y1, y2, v1, v2
x0 = Float64[0.994, 0., 0., -2.00158510637908252240537862224]
tend = 17.0652165601579625588917206249
T = [0.,tend;]

# Derivative function
function f(t::Float64, x::Vector{Float64}, dx::Vector{Float64})
    D1 = ((x[1] + μ)^2 + x[2]^2)^(3/2)
    D2 = ((x[1] + μ - 1)^2 + x[2]^2)^(3/2)
    dx[1] = x[3]
    dx[2] = x[4]
    dx[3] = x[1] + 2*x[4] - (1-μ)*(x[1] + μ)/D1 - μ*(x[1]- 1 + μ)/D2
    dx[4] = x[2] - 2*x[3] - (1-μ)*x[2]/D1 - μ*x[2]/D2
    nothing
end


# Test ode solver for accuracy
for tol=tolerances
    tout, xt = ode(f, T, x0; reltol=tol, abstol=tol)
    @test length(tout) == length(T) == length(xt)
    @test norm(xt[end]-xt[1]) < tol*1e5
end
