Dormand-Prince (4)5
===================

Efficient implementation of the adaptive Dormand-Prince (4)5 Runge-Kutta solver with dense output, in-place derivative computation and event handling.

Dense output
    If a large number of output points are needed it becomes inefficient to use separate Runge-Kutta steps to calculate them directly. Interpolation between the natural Runge-Kutta steps using the substep results allows a cheap calculation of intermediate points without additional, possibly expensive function evaluations.


Inplace derivative calculation
    Reallocating memory when calculating the derivative can in some cases lead to an annoying overhead. The derivative function therefore has to have the signature ``f(t, x, dx)`` where the result of the calculation has to written into ``dx``.


Event location and handling
    Finding points where some condition is fulfilled can be done by using the *event_locator* function ``f(t, x(t))`` which should change its sign at the time of the event. The solver finds this point automatically and efficiently without additional function evaluations and then calls the *event_callback* function ``f(t, x(t))``


Usage
-----

.. code-block:: julia

    >> using DormandPrince45
    >>
    >> T = [0.:0.1:1.;]
    >> x0 = [1., 0.]
    >>
    >> # Derivative function of harmonic oscillator
    >> function f(t,x,dx)
           dx[1] = x[2]
           dx[2] = -2.*x[1]
       end
    >>
    >> tout, xout = ode(f, T, x0)



API
---


ode
^^^

.. code-block:: julia

    function ode{T}(F::Function, tspan::Vector{Float64}, x0::Vector{T};
                    fout::Union{Function, Void} = nothing,
                    reltol::Float64 = 1.0e-6,
                    abstol::Float64 = 1.0e-8,
                    h0::Float64 = NaN,
                    hmin::Float64 = (tspan[end]-tspan[1])/1e9,
                    hmax::Float64 = (tspan[end]-tspan[1]),
                    display_initialvalue::Bool = true,
                    display_intermediatesteps::Bool = false,
                    )

Adaptive Runge-Kutta Dormand-Prince 4(5) solver with dense output.


**Arguments**

    F
        Derivative function with signature F(t, y, dy) which writes the
        derivative into dy.
    tspan
        Vector of times at which output should be displayed.
    x0
        Initial state.


**Optional Arguments**

    fout
        Function called to display the state at the given points of time
        with signature fout(t, x). If no function is given, ode_event returns
        a vector with the states at all points in time given in tspan.
    reltol
        Relative error tolerance.
    abstol
        Absolute error tolerance.
    h0
        Initial guess for the size of the time step. If no number is given an
        initial timestep is chosen automatically.
    hmin
        If the automatic stepsize goes below this limit the ode solver stops
        with an error.
    hmax
        Stepsize is never increased above this limit.
    display_initialvalue
        Call fout function at tspan[1].
    display_intermediatesteps
        Call fout function after every Runge-Kutta step.


ode_event
^^^^^^^^^

.. code-block:: julia

    function ode_event{T}(F::Function, tspan::Vector{Float64}, x0::Vector{T},
                    event_locator::Function, event_callback::Function;
                    fout::Union{Function, Void} = nothing,
                    reltol::Float64 = 1.0e-6,
                    abstol::Float64 = 1.0e-8,
                    h0::Float64 = NaN,
                    hmin::Float64 = (tspan[end]-tspan[1])/1e9,
                    hmax::Float64 = (tspan[end]-tspan[1]),
                    display_initialvalue::Bool = true,
                    display_intermediatesteps::Bool = false,
                    display_beforeevent::Bool = false,
                    display_afterevent::Bool = false
                    )

Adaptive Runge-Kutta Dormand-Prince 4(5) solver with event handling and dense output.


**Arguments**

    F
        Derivative function with signature F(t, y, dy) which writes the
        derivative into dy.
    tspan
        Vector of times at which output should be displayed.
    x0
        Initial state.
    event_locator
        Function used to find events with signature
            event_locator(t, x) returning a real value. If the sign of the
            returned value changes the event_callback function is called.
    event_callback
        Function that is called when an event happens. Its signature is
        event_callback(t, x) and it should return a CallbackCommand.
        The possible CallBack commands are:

            ``nojump``
                No changes in the dynamics. In this case x should not be
                changed inside the callback function.
            ``jump``
                The x vector has changed and time evolution continues from
                *t_event*.
            ``stop``
                The ode solver stops at the event time.


**Optional Arguments**

    fout
        Function called to display the state at the given points of time
        with signature fout(t, x). If no function is given, ode_event returns
        a vector with the states at all points in time given in tspan.
    reltol
        Relative error tolerance.
    abstol
        Absolute error tolerance.
    h0
        Initial guess for the size of the time step. If no number is given an
        initial timestep is chosen automatically.
    hmin
        If the automatic stepsize goes below this limit the ode solver stops
        with an error.
    hmax
        Stepsize is never increased above this limit.
    display_initialvalue
        Call fout function at tspan[1].
    display_intermediatesteps
        Call fout function after every Runge-Kutta step.
    display_beforeevent
        Call fout function immediately before an event.
    display_afterevent
        Call fout function immediately after an event.

