function e = eq(a,b)
% not floating point sensitive
e = isequal(a.ends([1 end]),b.ends([1 end]));
end