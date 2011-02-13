function B = repmat(A,m,n)
% REPMAT   Replicate and tile linops.

% See http://www.maths.ox.ac.uk/chebfun.

if nargin == 2
   if isscalar(m)
       n = m;
   else
       n = m(2);
       m = m(1);
   end
end

if any([m,n] == 0), B = []; return, end

B = A;
for k = 1:m-1
    B = [B ; A];
end

A = B;
for k = 1:n-1
    B = [B  A];
end

end
