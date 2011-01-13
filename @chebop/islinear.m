function islin = islinear(N)
% ISLINEAR Checks whether a chebop is linear.
% ISLINEAR(N) returns 1 if N is a linear operator, 0 otherwise.

[ignored ignored islin] = linearise(N,[],1);
