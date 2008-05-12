function e = double(d)
% DOUBLE Convert domain to double.
% DOUBLE(D) returns a vector containing the endpoints and breakpoints (in
% sorted order) of the domain D.
%
% If you want only the endpoints and not any breakpoints, use D(:).

e = d.ends;

end