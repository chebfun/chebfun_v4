function g = inv(f)
% INV Invert a chebfun
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if numel(f) > 1
    error('chebfun:inv:noquasi','no supprt for quasimatrices');
end

[d x] = domain(minandmax(f));

g = chebfun(@(x) op(f,x),d,'resampling',0);

function r = op(f,x)
for j = 1:length(x)
    temp = roots(f-x(j));
    if length(temp) > 1
        error('chebfun:inv:notmonotonic','chebfun must be monotonic');
    end
    r(j,1) = temp;
end
