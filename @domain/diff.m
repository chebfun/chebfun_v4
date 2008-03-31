function D = diff(d,m)

D = chebop( @(n) diffmat(n)*2/length(d), @(u) diff(u), d, 1 );
if nargin > 1
  D = mpower(D,m);
end

end