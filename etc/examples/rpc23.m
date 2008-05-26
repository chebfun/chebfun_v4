% rpc23 Remez algorithm 
% Given a function F and a positive integer N, this M-file constructs the
% best polynomial approximation of degree N in the infinity norm using the 
% Remez algorithm.
%
% At each step of this iterative method, a polynomial P is computed such 
% that the error F-P equioscillates on a reference grid {x_i}, that is,
% |F(x_i)-P(x_i)| = (-1)^i H, for a positive value H. The coefficients of
% this polynomial P are computed by solving a (N+2)x(N+2) linear system.
% The maximum absolute of F-P at a point ETA is computed and its closest
% point in the reference is exchanged with ETA. Thus, this is the so-called
% "one-point" exchange algorithm. The algorithm stops when the value
% |max(F-P)| - |H| is less than 1e-12.
%
% See Chapters 8 & 9 of "Approximation Theory and Methods" by M.J.D Powell
% RPC. 18/03/08
clear
clc, %clf
op = @(x) abs(cos(exp(x))) + 1./(x.^2+1);
interv = [0 3];
f = chebfun(op,interv);
n = 5;      % degree of the desired polynomial
m = n+1;
xk = linspace(interv(1),interv(2),n+2)';
delta = 1; 
while delta > 1e-12
    A = zeros(n+2,n+1);
    for k = 1:n+1, A(:,k) = xk.^(k-1); end
    A = [A (-1).^(0:n+1)'];
    c = A\op(xk);    
    cc = c(end-1:-1:1);
    h = c(end);
    p = chebfun(@(x) polyval(cc,x),interv,n+1);
    e = f - p;
    r = roots(diff(e));
    title(['|h| = ' num2str(abs(h),'%20.14f')]);
    ylabel('error = f - p')
    plot(e,'linewidth',2), hold on
    ylim([-.8 .8])
    pp=plot(xk,0*xk,'*k','markersize',10);
    box on
    [emax,pos] = max(abs(e(r)));
    xnew = r(pos); ynew = e(xnew); snew = sign(ynew);
    plot(xnew,ynew,'or','markersize',14);
    eta1 = max(find(xk<=xnew)); 
    eta2 = eta1+1; 
    if xnew >= xk(1) & xnew <= xk(end)
        if sign(e(xk(eta1))) == snew
            old = xk(eta1);
            xk(eta1) = xnew; 
        elseif sign(e(xk(eta2))) == snew
            old = xk(eta2);
            xk(eta2) = xnew; 
        else
            error('error function is not alternating its signs in the reference set')
        end
    elseif xnew < xk(1)
        if sign(e(xk(1))) == snew
            old = xk(1);
            xk(1) = xnew;
        else
            old = xk(n+2);            
            xk = [xnew; xk]; xk(end) = [];
        end
    elseif xnew > xk(end)
        if sign(e(xk(end))) == snew
            old = xk(n+2);
            xk(end) = xnew;
        else
            old = xk(1);
            xk = [xk; xnew]; xk(1) = [];
        end  
    end            
    pold = plot(old,0,'r*','markersize',10);
    pause()
    delete(pp)
    delete(pold)
    plot(xk,0*xk,'*k','markersize',10),
    plot(xnew,0,'*r','markersize',10),    
    hold off
    delta = abs(emax) - abs(h)
    pause()
end
figure
plot(f,'linewidth',2), hold on, plot(p,'r','linewidth',2), hold off
grid on