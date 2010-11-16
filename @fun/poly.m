function out = poly(f)
% POLY	Polynomial coefficients of a fun.
% POLY(F) returns the polynomial coefficients of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

v = chebpoly(f);
n = length(v);
out = zeros(1,n);
    
% Coefficients on the unit interval
if (n==1)
  out = v;
elseif (n==2)
  out(1:2) = v;
else
  % Initialise  
  tn = zeros(1,n);
  tnold1 = [0 1 zeros(1,n-2)];
  tnold2 = [1 zeros(1,n-1)];
  out = zeros(1,n);
  out(1:2) = [0 v(end)*tnold2(1)]+v(end-1)*tnold1(2:-1:1);
  % Recurrence
  for k = 3:n
    tn(1:k) = [0 2*tnold1(1:k-1)]-[tnold2(1:k-2) 0 0];
    out(1:k) = v(end-k+1)*tn(k:-1:1)+[0 out(1:k-1)];
    tnold2 = tnold1;
    tnold1 = tn;
  end
end

a = f.map.par(1);
b = f.map.par(2);
% Rescale if necessary
if ( a~=-1 || b~=1 )
    out = out(end:-1:1);
    
    % Constants for rescaling
    alpha = 2/(b-a); 
    beta = -(b+a)/(b-a);

    % Rescale coefficients to actual interval
    for j = 0:n-1
        k = j:n-1;
        binom = factorial(k)./(factorial(k-j)*factorial(j)); % Binomial coeff
        out(j+1) = sum(out(k+1).*binom.*beta.^(k-j).*alpha^(j));
    end
    out = out(end:-1:1);
end
