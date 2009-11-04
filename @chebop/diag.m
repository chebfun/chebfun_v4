function fout = diag(opin)
% Take the diagonal of a chebop. This is useful when the
% operator is diagonal, but needs more thought for cases
% when it is not.

d = domain(opin);
cheb1 = chebfun(1,d);
fout = opin*cheb1;

end