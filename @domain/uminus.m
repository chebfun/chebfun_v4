function d = uminus(d)
% -     Negate a domain's defining points.
% -D negates the endpoints and breakpoints of D, and reverses their order.

d.ends = -d.ends(end:-1:1);

end
