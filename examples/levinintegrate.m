%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Levin Collocation Method
%
%   by Sheehan Olver, based on [Levin 1982]
%
%   This computes the highly oscillatory integral of
%
%       f.*exp(1i.*w.*g)
%
%   over (0,1).  We us as an example
%
%       f = 1./(x+2);
%       g = cos(x-2);
%       w = 20000;
%
%   It computes this by rewriting the integral as an ODE
%
%       diff(u) + 1i.*w.*diff(g).*u = f
%
%   so that the indefinite integral of f.*exp(1i.*w.*g) is 
%
%       u.*exp(1i.*w.*g)
%
%   It solves this ODE using chebops.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[d x]= domain(0,1);
f = 1./(x+2);
g = cos(x-2);
D = diff(d);


%  the Levin method will be accurate for large and small w,
%  and the time taken is independent of w.
%  Here we take a reasonably large value of w.
w=20000;

L = D + 1i*w*diag(diff(g));


%   From asymptotic analysis, we know that there exists
%   a solution to the equation which is non-oscillatory,
%   though we do not know what initial condition it
%   satisfies.  Thus we find a particular solution to this
%   equation using chebops with no boundary conditions.
%
%   chebops gives a warning when \ is used without bcs,
%   so we turn off the warning.


s = warning('off','chebop:mldivide:bcnum');

u = L \ f;

%   and now we return the warning state to its
%   original value
warning(s);



% we now evaluate the antiderivative at the endpoints
% to obtain the integral.


u(1).*exp(1i.*w.*g(1))-u(0).*exp(1i.*w.*g(0))

   
%%
%  Here is a way to compute the integral 
%  using Clenshaw--Curtis quadrature.
%  As w becomes large, this takes an increasingly
%  long time as the oscillations must be resolved.
%  

sum(f.*exp(1i.*w.*g))