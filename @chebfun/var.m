function out = var(F)
% VAR   Variance.
% VAR(F) is the variance of the chebfun F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if F(1).trans
    out = transpose(var(transpose(F)));
else
    out = zeros(1,size(F,2));
    for k = 1:size(F,2)
        out(k) = mean((F(:,k)-mean(F(:,k))).^2);
    end
end

