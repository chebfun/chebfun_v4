function Fout = besselj(nu,F)
% BESSELJ   Bessel function of first kind of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

[r,c] = size(nu);
if r > 1 && c > 1    
    error('The first argument of besselj must be a vector of real numbers');
end

if c==1 && r == 1
    Fout = comp(F, @(x) real(besselj(nu,x)));
elseif c==1 && F.trans
    for k = 1:length(nu)
        Fout(k,:) = comp(F, @(x) real(besselj(nu(k),x)));
    end
elseif r==1 && ~F.trans    
    for k = 1:length(nu)
        Fout(:,k) = comp(F, @(x) real(besselj(nu(k),x)));
    end
else
    error('The parameters of besselj must be a row vector and a column chebfun, or a column vector and a row chebfun.')
end

for k = 1:numel(F)
  Fout(k).jacobian = anon('@(u) diag(-besselj(nu+1,F)+nu*Fout./F)*jacobian(F,u)',{'nu' 'F' 'Fout'},{nu F(k) Fout(k)});
  Fout(k).ID = newIDnum();
end