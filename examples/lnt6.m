% lnt6.m print a table of Chebyshev polynomials LNT 12.06

for n = 0:8
    disp(poly(fun([1 zeros(1,n)])));
end

% WHAT TO DO WITH RICFUNS??