function D = chebop_diff(fundomain)

if nargin<1
  fundomain = [-1 1];
end
D = chebop( @(n) diffmat(n)*2/diff(fundomain), @(u) diff(u), fundomain, 1 );
end