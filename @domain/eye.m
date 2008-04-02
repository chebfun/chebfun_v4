function I = eye(d)

I = chebop( @speye, @(u) u, d );

end