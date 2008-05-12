function e = eq(a,b)
% ==     Equality of domains
% Domains are considered equal if their endpoints are identical floating
% point numbers. Breakpoints are not considered.

e = isequal( a.ends([1 end]), b.ends([1 end]) );

end