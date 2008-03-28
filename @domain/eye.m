function I = eye(d)

I = chebop( @eye, @(u) u, d );

end