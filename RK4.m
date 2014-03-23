function [x v t] = RK4(f, x0, v0, T, dt)
%RK4.m
%Gudbrand Tandberg - gudbrandduff@gmail.com
%version 1.0
%
%Implementation of the Runge-Kutta 4 method for solving the second order
%differential equation x'' = f(x, x', t) from time t = 0 to t = T. The
%algorithm uses stepsize dt, and can be used for any number of dimensions.
%
% x_0: 1xdim row vector of initial positions (or some other quantity)
% v_0: 1xdim row vector of inital velocities (--"--)
%
%Returns the desired solution (x), its first differential (v) and the
%time-vector (t).

%Parameters:
dim = size(x0);
dim = dim(2);

dt2 = 0.5*dt;           %half the stepsize
N = round(T/dt);        %no. of evaluation points
t = linspace(0, T, N);  %time-vector

%Preallocations and inital conditions:
x = zeros(N, dim);      %solution vector
x(1,:) = x0;            %initial cond.
v = zeros(N, dim);      %first differential vector
v(1,:) = v0;            %initial cond.

%Solves the equation with the RK4 metod:
for n = 1:N-1
x1 = x(n,:);
v1 = v(n,:);
a1 = f(x1, v1, n*dt);

x2 = x(n,:) + dt2*v1;
v2 = v1 + a1*dt2;
a2 = f(x2 ,v2 , n*dt + dt2);

x3 = x1 + v2*dt2;
v3 = v1 + a2*dt2;
a3 = f(x3, v3, n*dt + dt2);

x4 = x1 + v3*dt;
v4 = v1 + a3*dt;
a4 = f(x4, v4, (n+1)*dt);

%March forward in time:
v(n+1,:) = v1 + dt/6*(a1+ 2*a2 + 2*a3 + a4);
x(n+1,:) = x1 + dt/6*(v1 + 2*v2 + 2*v3 + v4);

end
end