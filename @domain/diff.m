function D = diff(d)

D = chebop( @(n) diffmat(n)*2/length(d), @(u) diff(u), d, 1 );

end