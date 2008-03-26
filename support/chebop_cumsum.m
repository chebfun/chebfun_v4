function J = chebop_cumsum(fundomain)

if nargin<1
  fundomain = [-1 1];
end
J = chebop( @(n) cumsummat(n)*diff(fundomain)/2, @(u) cumsum(u), fundomain, -1 );
end