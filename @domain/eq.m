function e = eq(a,b)
% not floating point sensitive
e = isequal(a.ends,b.ends);
end