function l = length(d)
% LENGTH  Length of a domain's interval.
% LENGTH(D) returns the difference between endpoints, D(end)-D(1).

l = d.ends(end)-d.ends(1);