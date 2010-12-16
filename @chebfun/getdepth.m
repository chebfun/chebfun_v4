function d = getdepth(f)
% GETDEPTH Obtain the AD depth of a chebfun
% D = GETDEPTH(F) returns the depth of the anon stored in the chebfun F.
d = getdepth(f.jacobian);
end