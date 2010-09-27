function complexplot(n,rho)
% complexplot.m  Show image of regions in the complex plane under complex functions
%  n = 1: The square [-1 1] X [-1i 1i]
%  n = 2: The unit circle
%  n = 3: The Bernstein (aka Chebyshev) ellipse

if nargin == 0,    n = 1;  close all, end
if nargin < 2  &&  n == 3, rho = 1.8; end

x = chebfun('x');
S = chebfun;
switch n
    case 1
        for d = -1:.2:1, S = [S d+1i*x 1i*d+x]; end
    case 2
        for d = 0.1:.1:1,  S = [S d*exp(pi*1i*x) .5*(x+1)*exp(2*pi*1i*d)]; end
    case 3
        c = exp(1*pi*1i*x); x2 = .5*(rho-1)*(x+1)+1;
        for d = 0:.1:1,  S = [S exp(d*log(rho))*c x2*exp(1i*pi*d) x2*exp(-1i*pi*d)]; end
        S = .5*(S+1./S);
end


while true
    s = input('function of z to plot? (in quotes or anonymous function).\n');
    if isempty(s), return, end
    if ischar(s), 
        f = inline(s);
    elseif isa(s,'function_handle'), 
        f = s; 
    end
    plot(f(S),'b'), shg, axis equal
end
