function Fout = besselj(nu,F)
% BESSELJ   Bessel function of first kind of a chebfun.
%  BESSELJ(NU,F)
%
%  See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

[r,c] = size(nu);
if r > 1 && c > 1
    error('CHEBFUN:besselj:nu','The first argument of besselj must be a vector of real numbers');
end

if max(size(nu)) > 1 && min(size(F)) > 1
    error('CHEBUN:besselj:quasi','Cannot handle both a vector of nu and a quasimatrix input in besselj.');
end

if c == 1 && r == 1 % single nu
    Fnu = F.^nu;
    Fout = Fnu.*comp(F,@(x) h(nu,x));
    nu = repmat(nu,numel(F),1);
elseif (c == 1 && F.trans) || (r == 1 && ~F.trans)
    for k = 1:length(nu)
        Fnu(k,:) = F.^nu(k);
        Fout(k,:) = Fnu(k,:).*comp(F,@(x) h(nu(k),x));
    end
else
    error('CHEBFUN:besselj:trans',['The parameters of besselj must be a row ',...
        'vector and a column chebfun, or a column vector and a row chebfun.'])
end


for k = 1:numel(Fout)
    [Fnu(k) Fout(k)] = overlap(Fnu(k),Fout(k));
    for j = 1:Fnu(k).nfuns
        if isreal(Fnu(k).funs(j).vals)
            Fout(k).funs(j) = real(Fout(k).funs(j));
        end
    end
    if numel(Fout) == numel(F) 
        Fout(k).jacobian = anon('@(u) diag(-besselj(nu+1,F)+nu*Fout./F)*diff(F,u)', ...
            {'nu' 'F' 'Fout'},{nu(k) F(k) Fout(k)});
    else
        Fout(k).jacobian = anon('@(u) diag(-besselj(nu+1,F)+nu*Fout./F)*diff(F,u)', ...
            {'nu' 'F' 'Fout'},{nu(k) F Fout(k)});
    end
    Fout(k).ID = newIDnum();
end

function y = h(nu,x)
% h(nu,x) = J(nu,x)/x^nu is smooth!
y = besselj(nu,x)./x.^nu;
y(x==0) = 2^(-nu)./gamma(nu+1);
