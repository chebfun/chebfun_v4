function Z = zeros(d)

Z = chebop( @zeros, @(u) 0*u, d );
end