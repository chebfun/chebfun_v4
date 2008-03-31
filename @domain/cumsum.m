function J = cumsum(d,m)

J = chebop( @(n) cumsummat(n)*length(d)/2, @(u) cumsum(u), d, -1 );
if nargin > 1
  J = mpower(J,m);
end

end