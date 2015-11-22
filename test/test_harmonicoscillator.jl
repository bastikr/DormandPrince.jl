using Base.Test
using DormandPrince45

tolerances = [1e-3, 1e-5, 1e-7]

ζ = 0.1
ω = 3.

T = [0.:0.1:10.;]
x0 = Float64[5., 0.]

# Derivative function for damped harmonic oscillator
function f(t::Float64, x::Vector{Float64}, dx::Vector{Float64})
    dx[1] = x[2]
    dx[2] = -2*ζ*ω*x[2] - ω^2*x[1]
    nothing
end


# Analytic solution
γp = -ζ*ω + ω*sqrt(complex(ζ^2 - 1))
γm = -ζ*ω - ω*sqrt(complex(ζ^2 - 1))
A = x0[1] + (γp*x0[1] - x0[2])/(γm - γp)
B = - (γp*x0[1] - x0[2])/(γm - γp)

function F(t::Float64)
    return real(A*exp(γp*t) + B*exp(γm*t))
end


# Test ode solver for accuracy
for tol=tolerances
    tout, xt = ode(f, T, x0; reltol=tol, abstol=tol)
    @test length(tout) == length(T) == length(xt)
    err = [abs(xt[i][1] - F(tout[i])) for i=1:length(T)]
    @test tol/5 < maximum(err) < 5*tol
end


# Test fout function
for tol=tolerances
    N = 0
    function fout(t, x)
        N += 1
        @test abs(x[1] - F(t)) < 5*tol
    end
    result = ode(f, T, x0, fout; reltol=tol, abstol=tol)
    @test N == length(T)
    @test result == nothing
end