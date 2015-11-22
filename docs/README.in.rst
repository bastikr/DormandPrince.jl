Dormand-Prince (4)5
===================

Efficient implementation of an adaptive Dormand-Prince (4)5 Runge-Kutta solver with dense output, in-place derivative computation and event handling.

Dense output
    If a large number of output points is needed it becomes inefficient to use separate Runge-Kutta steps to calculate them directly. Interpolation between the natural Runge-Kutta steps by using all the substep results allows a cheap calculation of intermediate points without additional, possibly expensive function evaluations.


In-place derivative calculation
    Reallocating memory when calculating the derivative can in some cases lead to an annoying overhead. The derivative function therefore has the signature ``f(t, x, dx)`` where the result of the calculation has to be written into ``dx``.


Event location and handling
    Finding points where some condition is fulfilled can be done by using a real valued function ``f(t, x(t))`` which changes its sign when the event occurs.


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

.. expand function src/DormandPrince45.jl::ode


ode_event
^^^^^^^^^

.. expand function src/DormandPrince45.jl::ode_event

