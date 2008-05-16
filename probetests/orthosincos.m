function pass = orthosincos

% TAD

for n = 1:5
  S(:,n) = chebfun(@(x) sin(n*x),[0 2*pi]);
  C(:,n) = chebfun(@(x) cos(n*x),[0 2*pi]);
end
ip = S'*G;
pass = norm(ip - pi*eye(5)) < 10*eps;

end
