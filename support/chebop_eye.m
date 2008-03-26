function I = chebop_eye(fundomain)

if nargin<1
  fundomain = [-1 1];
end
I = chebop( @speye, @(u) u, fundomain );

end