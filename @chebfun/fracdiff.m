function u = fracdiff(u,alpha)
% FRACDIFF Fractional derivative of a chebfun
%  V = FRACDIFF(U,ALPHA) computes the fractional derivative V of order ALPHA
%  (as defined by the Riemann–Liouville integral) of the chebfun U.
%
%  If [a b] = domain(U), then V(a) = 0. U may be a quasimatrix.
%
%  U may be a quasimatrix, but piecewise chebfuns are not yet supported.
%
%  Example:
%    u = chebfun('sin(x)',[0 pi]);
%    k = 1;
%    for alpha = 0.1:.1:1
%    k = k + 1;
%    u(:,k) = fracdiff(u(:,1),alpha);
%        plot(u), drawnow
%    end
%
%  See also chebfun/fracint, chebfun/diff.
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.
%
%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: hale $: $Rev: 1017 $:
%  $Date: 2010-01-22 08:53:23 +0000 (Fri, 22 Jan 2010) $:

% Get the domain
[a b] = domain(u);

% Some checking of the value of u at the left
% ua = feval(u,a);
% if any(abs(ua) > u.scl*chebfunpref('eps'))
%     ua
%     warning('CHEBFUN:fracint:zeros', ...
%         'FRACINT and FRACDIFF assume the chebfun is zero at the left boundary.');
% end

% Is alpha an integer?
if round(alpha) == alpha
    % Integer alpha is just standard differentiation
    u = diff(u,alpha);
else
    % Call fracint on the derivative
    k = ceil(alpha);
    u = fracint(diff(u,k),k-alpha);
end

end