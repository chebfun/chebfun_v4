function J = cumsum(d)
J = chebop( @(n) cumsummat(n)*length(d)/2, @(u) cumsum(u), d, -1 );
end