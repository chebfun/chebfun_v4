function g = inv(f)
% INV Invert a chebfun
%  G = INV(F) will attempt to invert the monotonic chebfun F.
%  If F has zero derivatives at its endpoints, then it is advisable
%  to turn Splitting ON.
%
%  Note, this function is experimental.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if numel(f) > 1
    error('chebfun:inv:noquasi','no support for quasimatrices');
end

domainf = domain(f);
[domaing x] = domain(minandmax(f));

g = chebfun(@(x) op(f,x), domaing, 'resampling', 0);

% Scale so that the range of g is the domain of f
[rangeg gx] = minandmax(g);
g = g + (x-gx(2))*(domainf(1)-rangeg(1)) ...
      + (x-gx(1))*(domainf(2)-rangeg(2));

function r = op(f,x)
tol = chebfunpref('eps');
r = zeros(length(x),1);
for j = 1:length(x)
    temp = roots(f-x(j));
    if length(temp) ~= 1
        err = abs(feval(f,f.ends)-x(j));
        [temp k] = min(err);
        if err(k) > 100*tol*abs(x(j))
            error('chebfun:inv:notmonotonic','chebfun must be monotonic');
        end
    end
    r(j,1) = temp;
end
