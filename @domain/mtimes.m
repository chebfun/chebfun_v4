function d = mtimes(d,a)
% *      Scale a domain.
% A*D or D*A for domain D and scalar A multiplies all the endpoints and
% breakpoints of D by A.  If A is negative, the ordering of the points is
% then reversed.

d = times(d,a);

end