function d = minus(d,a)
% -      Translate a domain to the left.
% D-A for domain D and scalar A subtracts A from all of the domain D's
% endpoints and breakpoints.

d = plus(d,-a);

end